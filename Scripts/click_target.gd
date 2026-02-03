class_name ClickTarget extends Area2D

var hello_vars : String = "hello "
var is_target: bool = false

signal has_been_clicked(is_target:bool)

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		has_been_clicked.emit(is_target)
