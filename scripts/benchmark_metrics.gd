extends RefCounted
class_name BTVBenchmarkMetrics

## Pure frame-time summarizer. Inputs are measured milliseconds; this class
## does not claim to collect GPU, memory, thermal or device telemetry.


static func summarize_frame_times(samples_ms: Array[float], stutter_threshold_ms: float = 33.3) -> Dictionary:
	if samples_ms.is_empty() or not is_finite(stutter_threshold_ms) or stutter_threshold_ms <= 0.0:
		return {}
	var sorted_samples: Array[float] = []
	var total := 0.0
	var stutter_count := 0
	for sample in samples_ms:
		if not is_finite(sample) or sample < 0.0:
			return {}
		sorted_samples.append(sample)
		total += sample
		if sample > stutter_threshold_ms:
			stutter_count += 1
	sorted_samples.sort()
	var median := _percentile_nearest_rank(sorted_samples, 0.5)
	var p95 := _percentile_nearest_rank(sorted_samples, 0.95)
	return {
		"sample_count": sorted_samples.size(),
		"average_ms": total / float(sorted_samples.size()),
		"median_ms": median,
		"p95_ms": p95,
		"max_ms": sorted_samples[sorted_samples.size() - 1],
		"stutter_threshold_ms": stutter_threshold_ms,
		"stutter_count": stutter_count,
	}


static func _percentile_nearest_rank(sorted_samples: Array[float], percentile: float) -> float:
	var index := clampi(int(ceil(percentile * float(sorted_samples.size()))) - 1, 0, sorted_samples.size() - 1)
	return sorted_samples[index]
