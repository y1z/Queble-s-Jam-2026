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

	_create_valid_location(columns, rows, spawn_area_shape.shape.get_rect())

	for i in test_amount:
		instanced_click_entities.append(click_entity_template.instantiate())

	for i in test_amount:
		var temp: ClickEntity = instanced_click_entities[i] as ClickEntity
		# HACK to trigger the _ready function
		add_child(temp)
		move_to_valid_spawn_location(temp)

	### HACK need to happend after spawning the click_entities
	var sequence_of_sprites := _create_sequence_of_sprites(GameSprites.random_sprite_form())
	for i in instanced_click_entities.size():
		var temp: ClickEntity = instanced_click_entities[i] as ClickEntity
		temp.change_to_click_form(sequence_of_sprites[i])
	pass # Replace with function body.


func _input(event: InputEvent) -> void:
	pass


func move_to_valid_spawn_location(click_entity: ClickEntity) -> void:
	var has_location_been_found: bool = false;
	var safety_count: int = 1000
	while not (has_location_been_found) and (safety_count > 1):
		var possible_location_index: int = randi_range(0, occupied_valid_spawn_locations.size() - 1)
		if occupied_valid_spawn_locations[possible_location_index] == false:
			occupied_valid_spawn_locations[possible_location_index] = true
			click_entity.move_to_with_offset(valid_spawn_locations[possible_location_index], click_entity.get_rect2().size * 0.5)
			has_location_been_found = true

		safety_count -= 1

	pass


func clear_spawn_locations() -> void:
	for i in valid_spawn_locations.size():
		occupied_valid_spawn_locations[i] = false


func _create_valid_location(width: int, height: int, rect: Rect2) -> void:
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
	#print(valid_spawn_locations)


## unique_sprite_form : This mean that only ONE should exist in the array
func _create_sequence_of_sprites(unique_sprite_form: Enums.SpriteForms) -> Array[Enums.SpriteForms]:
	var result: Array[Enums.SpriteForms]
	var valid_sprite_forms: Array[Enums.SpriteForms]

	for i: Enums.SpriteForms in Enums.SpriteForms.values():
		if i == unique_sprite_form:
			continue
		valid_sprite_forms.append(i)
		pass

	for i in(instanced_click_entities.size() - 1):
		var sprite_form_index: int = randi_range(0, valid_sprite_forms.size() - 1)
		result.append(valid_sprite_forms[sprite_form_index])

	result.append(unique_sprite_form)

	return result


func _draw() -> void:
	draw_rect(spawn_area_shape.shape.get_rect(), background_color)
	#for i in valid_spawn_locations:
		#draw_circle(i, 10.0, Color.AQUA)
	pass
