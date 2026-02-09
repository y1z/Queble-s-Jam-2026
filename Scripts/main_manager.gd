extends Node2D

const DEFAULT_COLUMNS: int = 10
const DEFAULT_ROWS: int = 10
const DEFAULT_TIMER_TIME: float = 15.0

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
var sound_effect: AudioStreamPlayer2D = null
var game_ui: GameUI
var game_timer: GameTimer
var score : int = 0

var sound = preload("uid://c3jpcvoxi7pl")


func _ready() -> void:
	const test_amount: int = 10
	click_entity_template = load("uid://gihv7st6kkhx")
	spawn_area = % "spawn_area"
	spawn_area_shape = spawn_area.find_child("spawn_area_shape") as CollisionShape2D
	game_ui = %Control as GameUI
	assert(game_ui != null)
	sound_effect = %AudioStreamPlayer2D

	if rows < 1:
		rows = DEFAULT_ROWS
	if columns < 1:
		columns = DEFAULT_COLUMNS

	game_timer = GameTimer.new()
	game_timer.time_until_event = DEFAULT_TIMER_TIME
	game_timer.event_timing_end.connect(on_event_game_timer_end) ;
	_create_valid_location(columns, rows, spawn_area_shape.shape.get_rect())

	for i in test_amount:
		instanced_click_entities.append(click_entity_template.instantiate())

	# HACK to trigger the _ready function
	for i in instanced_click_entities:
		var temp: ClickEntity = i as ClickEntity
		add_child(temp)

	EventBus.clicked_on_target.connect(_on_event_click_target)
	generate_play_field_thing()
	pass # Replace with function body.


func _process(delta: float) -> void:
	game_timer.start_timing()
	game_timer._process(delta)
	game_ui.update_proccess_label(game_timer.time_until_event - game_timer.current_delta_time)


func _exit_tree() -> void:
	EventBus.clicked_on_target.disconnect(_on_event_click_target)


func _draw() -> void:
	draw_rect(spawn_area_shape.shape.get_rect(), background_color)
	#for i in valid_spawn_locations:
		#draw_circle(i, 10.0, Color.AQUA)
	pass


func move_to_valid_spawn_location(click_entity: ClickEntity) -> void:
	click_entity.move_to(Vector2.ZERO)
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


func _on_event_click_target(data: EventBus.clickedOnTargetData) -> void:
	if data.is_target:
		sound_effect.stream = sound
		sound_effect.play()
		clear_spawn_locations()
		generate_play_field_thing()
		score = score + 10
		game_ui.update_score_label(score)
		#get_tree().reload_current_scene()
	pass


func generate_play_field_thing() -> void:

	for i in instanced_click_entities:
		var temp: ClickEntity = i as ClickEntity
		move_to_valid_spawn_location(temp)
	### HACK need to happend after spawning the click_entities
	var sprite_for_to_look_for := GameSprites.random_sprite_form()
	game_ui.change_sprite_for(sprite_for_to_look_for)
	var sequence_of_sprites := _create_sequence_of_sprites(sprite_for_to_look_for)
	for i in instanced_click_entities.size():
		var temp: ClickEntity = instanced_click_entities[i] as ClickEntity
		temp.change_to_click_form(sequence_of_sprites[i])
		temp.is_target = false

	var selected_traget := instanced_click_entities[instanced_click_entities.size() - 1] as ClickEntity
	selected_traget.is_target = true


func on_event_game_timer_end() -> void:
	print("end")
	get_tree().reload_current_scene()
	pass
