class_name ClickEntity extends Node2D

@export_group("VARIABLES")
@export var is_target: bool = false
@export var modulate_color: Color = Color.WHITE:
	set(value):
		modulate_color = value
		if sprite != null:
			sprite.modulate = modulate_color
	get:
		return modulate_color

var click_target: ClickTarget
var click_target_shape: CollisionShape2D
var sprite: Sprite2D
var game_timer: GameTimer = GameTimer.new()


func _init() -> void:
	Debug.d_print_verbose(self.name.c_escape(), "_init")


func _ready() -> void:
	click_target = %Area2D as ClickTarget
	Debug.d_print(self.name, "_ready")
	if click_target == null:
		printerr("click_target is null FIX THAT")
	click_target_shape = % "CollisionShape2D"
	if click_target_shape == null:
		printerr("click_target_shape is null FIX THAT")
	sprite = %Sprite
	sprite.modulate = modulate_color
	click_target.has_been_clicked.connect(_on_has_been_clicked_on)
	pass # Replace with function body.


func _process(delta: float) -> void:
	game_timer._process(delta)
	pass


func get_rect2() -> Rect2:
	return sprite.get_rect()


func move_to(new_pos: Vector2) -> void:
	self.position = new_pos


func move_to_with_offset(new_post: Vector2, offset: Vector2) -> void:
	self.position = self.position + new_post + offset


func _exit_tree() -> void:
	Debug.d_print_verbose(self.name, "_exit_tree")
	click_target.has_been_clicked.disconnect(_on_has_been_clicked_on)


func _on_has_been_clicked_on(_is_target: bool) -> void:
	Debug.d_print(self.name.c_escape(), "event _on_has_been_clicked_on triggered")
	pass


func _on_event_timing_end() -> void:
	modulate_color = Color.CORNFLOWER_BLUE
	pass
