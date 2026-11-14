#!/usr/bin/env python3
"""Run a Luau script inside a real Roblox place through Open Cloud Luau Execution.

This is the headless runtime path: Roblox launches a server for the place
version and executes the script with full engine API access. No Studio
installation is required on the machine that runs this script.

Authentication
--------------
The API key is read from the environment variable named by --key-env
(default ROBLOX_API_KEY). The key is never printed, never written to disk and
never passed as a command-line argument.

Usage
-----
    export ROBLOX_API_KEY="..."
    python run_luau_task.py --universe 123456 --place 654321 --script task.luau

    # show exactly what would be sent, without contacting Roblox
    python run_luau_task.py --universe 123456 --place 654321 --script task.luau --dry-run

Exit codes
----------
    0  task completed and the script reported no failure
    1  task failed, the API refused the request, or the script reported failures
    2  usage error
"""

from __future__ import annotations

import argparse
import json
import os
import sys
import time
import urllib.error
import urllib.request

BASE_URL = "https://apis.roblox.com"
DEFAULT_KEY_ENV = "ROBLOX_API_KEY"
POLL_INTERVAL_SECONDS = 3
DEFAULT_TIMEOUT_SECONDS = 300


def _request(method: str, url: str, api_key: str, payload: dict | None = None) -> dict:
    body = json.dumps(payload).encode("utf-8") if payload is not None else None
    request = urllib.request.Request(url=url, data=body, method=method)
    request.add_header("x-api-key", api_key)
    request.add_header("Accept", "application/json")
    if body is not None:
        request.add_header("Content-Type", "application/json")
    try:
        with urllib.request.urlopen(request, timeout=60) as response:
            raw = response.read().decode("utf-8")
            return json.loads(raw) if raw.strip() else {}
    except urllib.error.HTTPError as error:
        detail = error.read().decode("utf-8", "replace")
        try:
            parsed = json.loads(detail)
            message = parsed.get("message") or detail
        except json.JSONDecodeError:
            message = detail
        raise SystemExit(f"Open Cloud rejected {method} {url}: HTTP {error.code}: {message[:400]}")
    except urllib.error.URLError as error:
        raise SystemExit(f"Could not reach the Open Cloud API: {error.reason}")


def _create_task(universe: str, place: str, script: str, api_key: str) -> dict:
    url = f"{BASE_URL}/cloud/v2/universes/{universe}/places/{place}/luau-execution-session-tasks"
    return _request("POST", url, api_key, {"script": script})


def _task_path(response: dict) -> str:
    path = response.get("path")
    if isinstance(path, str) and path:
        return path if path.startswith("http") else f"{BASE_URL}{path}"
    task_id = response.get("taskId") or response.get("id")
    if task_id:
        return (
            f"{BASE_URL}/cloud/v2/universes/PLACE/places/PLACE/luau-execution-sessions/SESSION"
            f"/tasks/{task_id}"
        )
    raise SystemExit(f"Unexpected create-task response: {json.dumps(response)[:400]}")


def _poll(path: str, api_key: str, timeout_seconds: int) -> dict:
    deadline = time.time() + timeout_seconds
    while time.time() < deadline:
        task = _request("GET", path, api_key)
        state = str(task.get("state", "")).upper()
        if state in {"COMPLETE", "FAILED", "CANCELLED"}:
            return task
        time.sleep(POLL_INTERVAL_SECONDS)
    raise SystemExit(f"Timed out after {timeout_seconds}s waiting for the Luau task to finish.")


def _fetch_logs(task: dict, api_key: str) -> str:
    path = task.get("logsPath") or task.get("logs")
    if not isinstance(path, str) or not path:
        return ""
    if not path.startswith("http"):
        path = f"{BASE_URL}{path}"
    try:
        request = urllib.request.Request(url=path, method="GET")
        request.add_header("x-api-key", api_key)
        request.add_header("Accept", "application/json")
        with urllib.request.urlopen(request, timeout=60) as response:
            payload = json.loads(response.read().decode("utf-8"))
    except (urllib.error.URLError, urllib.error.HTTPError, json.JSONDecodeError):
        return ""
    entries = payload.get("logs") or payload.get("entries") or []
    lines = []
    for entry in entries:
        if isinstance(entry, dict):
            lines.append(str(entry.get("message") or entry.get("text") or entry))
        else:
            lines.append(str(entry))
    return "\n".join(lines)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--universe", required=True, help="Roblox universe (experience) id")
    parser.add_argument("--place", required=True, help="Roblox place id")
    parser.add_argument("--script", required=True, help="Luau script to execute inside the place")
    parser.add_argument("--key-env", default=DEFAULT_KEY_ENV, help=f"environment variable holding the API key (default {DEFAULT_KEY_ENV})")
    parser.add_argument("--timeout", type=int, default=DEFAULT_TIMEOUT_SECONDS, help="seconds to wait for the task")
    parser.add_argument("--dry-run", action="store_true", help="print the request without sending it")
    arguments = parser.parse_args()

    try:
        with open(arguments.script, "r", encoding="utf-8") as handle:
            script = handle.read()
    except OSError as error:
        raise SystemExit(f"Could not read {arguments.script}: {error}")

    url = f"{BASE_URL}/cloud/v2/universes/{arguments.universe}/places/{arguments.place}/luau-execution-session-tasks"

    if arguments.dry_run:
        print(json.dumps({"method": "POST", "url": url, "script_bytes": len(script)}, indent=2))
        return 0

    api_key = os.environ.get(arguments.key_env, "").strip()
    if not api_key:
        raise SystemExit(
            f"No API key in ${arguments.key_env}. Create one at https://create.roblox.com/dashboard/credentials "
            f"with the 'Luau Execution' permission for this experience."
        )

    created = _create_task(arguments.universe, arguments.place, script, api_key)
    path = _task_path(created)
    task = _poll(path, api_key, arguments.timeout)

    state = str(task.get("state", "")).upper()
    logs = _fetch_logs(task, api_key)
    results = task.get("results") or task.get("output", {}).get("results") if isinstance(task.get("output"), dict) else task.get("results")

    print("=" * 72)
    print(f"Open Cloud Luau Execution — state: {state}")
    print("=" * 72)
    if logs:
        print(logs)
    if results is not None:
        print("-" * 72)
        print("results:")
        print(json.dumps(results, indent=2, default=str)[:8000])

    if state != "COMPLETE":
        print(f"\nTask did not complete successfully: {state}")
        return 1

    # A script that returns a table with failed > 0 reports failure.
    failed = 0
    if isinstance(results, dict):
        failed = int(results.get("failed", 0) or 0)
    elif isinstance(results, list):
        for entry in results:
            if isinstance(entry, dict) and entry.get("ok") is False:
                failed += 1
    if failed:
        print(f"\nEngine test reported {failed} failure(s).")
        return 1

    print("\nEngine test task completed with no reported failures.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
