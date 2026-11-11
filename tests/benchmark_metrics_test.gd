extends SceneTree
## Deterministic tests for benchmark frame-time summaries.

const Metrics = preload("res://scripts/benchmark_metrics.gd")
var failures := 0


func _initialize() -> void:
	_run()


func _run() -> void:
	var samples: Array[float] = [16.0, 17.0, 20.0, 40.0, 80.0]
	var summary: Dictionary = Metrics.summarize_frame_times(samples, 33.3)
	_check(summary.get("sample_count", 0) == 5, "BENCHMARK_METRICS: sample count")
	_check(is_equal_approx(float(summary.get("average_ms", -1.0)), 34.6), "BENCHMARK_METRICS: arithmetic mean")
	_check(is_equal_approx(float(summary.get("median_ms", -1.0)), 20.0), "BENCHMARK_METRICS: median")
	_check(is_equal_approx(float(summary.get("p95_ms", -1.0)), 80.0), "BENCHMARK_METRICS: nearest-rank p95")
	_check(is_equal_approx(float(summary.get("max_ms", -1.0)), 80.0), "BENCHMARK_METRICS: maximum")
	_check(summary.get("stutter_count", -1) == 2, "BENCHMARK_METRICS: threshold count")
	_check(Metrics.summarize_frame_times([]).is_empty(), "BENCHMARK_METRICS: empty input rejected")
	_check(Metrics.summarize_frame_times([16.0, -1.0]).is_empty(), "BENCHMARK_METRICS: negative sample rejected")
	_check(Metrics.summarize_frame_times([16.0, INF]).is_empty(), "BENCHMARK_METRICS: non-finite sample rejected")
	_check(Metrics.summarize_frame_times([16.0], 0.0).is_empty(), "BENCHMARK_METRICS: invalid threshold rejected")
	print("\nBENCHMARK_METRICS_TESTS: ", "PASS" if failures == 0 else "FAIL (%d failures)" % failures)
	quit(1 if failures > 0 else 0)


func _check(condition: bool, label: String) -> void:
	if condition:
		print("PASS: ", label)
	else:
		failures += 1
		printerr("FAIL: ", label)
