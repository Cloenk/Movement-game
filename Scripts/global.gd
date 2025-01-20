extends Node

static func smooth_nudgev(start: Vector3, end: Vector3, weight: float, delta: float):
	return start.lerp(end, 1.0 - exp(-weight * delta))

static func smooth_nudgev_rot(start: Vector3, end: Vector3, weight: float, delta: float):
	return start.slerp(end, 1.0 - exp(-weight * delta))
