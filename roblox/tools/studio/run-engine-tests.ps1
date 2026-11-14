# Run the BTV Roblox engine test harness inside a real Roblox Studio instance.
#
# Requires: Windows or macOS, Node 20+, and the pinned Rojo build.
#   winget install Rojo.Rojo      (or download from https://rojo.space)
#   npm install -g run-in-roblox
#
# run-in-roblox installs the Roblox Studio build automatically, so Studio does
# not have to be installed by hand.
#
#   pwsh roblox/tools/studio/run-engine-tests.ps1
#   pwsh roblox/tools/studio/run-engine-tests.ps1 -Clients 2
param(
	[int]$Clients = 1,
	[int]$TimeoutSeconds = 900
)

$ErrorActionPreference = "Stop"
$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "../../..")
Push-Location (Join-Path $repoRoot "roblox")

try {
	if (-not (Get-Command rojo -ErrorAction SilentlyContinue)) {
		throw "Rojo is not on PATH. Install it from https://rojo.space"
	}
	if (-not (Get-Command run-in-roblox -ErrorAction SilentlyContinue)) {
		throw "run-in-roblox is not on PATH. Run: npm install -g run-in-roblox"
	}

	New-Item -ItemType Directory -Force -Path build | Out-Null
	Write-Host "Building the test place..."
	rojo build test.project.json --output build/BTVRobloxTest.rbxlx

	Write-Host "Launching Roblox Studio with $Clients client(s)..."
	$output = & run-in-roblox run `
		--script tools/engine-task.luau `
		--place-file build/BTVRobloxTest.rbxlx `
		--universe-id 0 `
		--place-id 0 `
		--creator-id 0 `
		--creator-type 0 `
		--num-clients $Clients 2>&1

	$output | Tee-Object -FilePath build/studio-run.log
	if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
	if ($output -match "FAIL ") {
		Write-Error "Engine tests reported a failure. See build/studio-run.log"
		exit 1
	}
	Write-Host "Engine tests passed."
}
finally {
	Pop-Location
}
