class_name GameUI extends Node

var main_panel: Panel
var tex_rect: TextureRect
var time_label: Label
var score_label: Label


func _ready() -> void:
	main_panel = %Panel
	tex_rect = %TextureRect
	time_label = % "time lable"
	score_label = %"score label"
	pass # Replace with function body.


func update_proccess_label(time: float):
	time_label.text = str(time)

func update_score_label(new_score:int):
	score_label.text = "Score = " + str(new_score)
	

func change_sprite_for(which_sprite: Enums.SpriteForms) -> void:
	tex_rect.texture = GameSprites.GAME_SPRITES[which_sprite]
	pass
