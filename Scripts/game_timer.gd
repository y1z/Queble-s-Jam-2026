class_name GameTimer extends Node

signal event_timing_end;

var current_delta_time: float = 0.0

var time_until_event: float = 1.0:
	set(value):
		time_until_event = clampf(value, 0.001, 9999999999999999999.0)

var _is_timing: bool = false;


func _process(delta: float) -> void:
	if _is_timing == false: return
	current_delta_time += delta
	if current_delta_time >= time_until_event:
		current_delta_time = 0.0
		event_timing_end.emit()

	pass


func init() -> void:
	current_delta_time = 0.0
	_is_timing = false


func start_timing() -> void:
	_is_timing = true


func end_timing() -> void:
	_is_timing = false
