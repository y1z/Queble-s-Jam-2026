extends Node2D

const DEFAULT_COLUMNS: int = 10
const DEFAULT_ROWS: int = 10

@export_group("VARIABLES")
@export var columns: int
@export var rows: int
@export var background_color: Color = Color.BLACK:
	set(value):
		background_color = value
		queue_redraw()

var click_entity_template: Resource = preload("uid://gihv7st6kkhx")
var instanced_click_entities: Array[Node]
var spawn_area: Area2D
var spawn_area_shape: CollisionShape2D
var valid_spawn_locations: Array[Vector2]
var occupied_valid_spawn_locations: Array[bool]


func _ready() -> void:
	const test_amount: int = 10
	click_entity_template = load("uid://gihv7st6kkhx")
	spawn_area = % "spawn_area"
	spawn_area_shape = spawn_area.find_child("spawn_area_shape") as CollisionShape2D

	if rows < 1:
		rows = DEFAULT_ROWS
	if columns < 1:
		columns = DEFAULT_COLUMNS

	_create_value_location(columns, rows, spawn_area_shape.shape.get_rect())

	for i in test_amount:
		instanced_click_entities.append(click_entity_template.instantiate())

	var starting_position := spawn_area_shape.shape.get_rect().position
	for i in test_amount:
		var temp: ClickEntity = instanced_click_entities[i] as ClickEntity
		# HACK to trigger the _ready function
		add_child(temp)

	pass # Replace with function body.


func _process(delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	pass


func _create_value_location(width: int, height: int, rect: Rect2) -> void:
	assert(width > 0, "Negative values are a error")
	assert(height > 0, "Negative values are a error")
	var top_left: Vector2 = rect.position
	var top_right: Vector2 = rect.position + Vector2(rect.size.x, 0.0);
	var bottom_left: Vector2 = rect.end - Vector2(rect.size.x, 0.0);
	var left_to_right_delta: Vector2 = (top_right - top_left) / width
	var top_to_bottom_delta: Vector2 = (bottom_left - top_left) / height
	var current_pos: Vector2 = rect.position
	for y in height:
		for x in width:
			valid_spawn_locations.append(current_pos)
			occupied_valid_spawn_locations.append(false)
			current_pos = current_pos + left_to_right_delta
			pass
		current_pos = current_pos + top_to_bottom_delta
		current_pos.x = rect.position.x
	print(valid_spawn_locations)


func _draw() -> void:
	draw_rect(spawn_area_shape.shape.get_rect(), background_color)
	for i in valid_spawn_locations:
		draw_circle(i, 10.0, Color.AQUA)
	pass
