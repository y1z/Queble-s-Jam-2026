extends Node

const GAME_SPRITES: Dictionary[Enums.SpriteForms, Resource] = {
	Enums.SpriteForms.Form1: preload("uid://dusabx6hn5e2d"),
	Enums.SpriteForms.Form2: preload("uid://che5n4rwlfx8n"),
	Enums.SpriteForms.Form3: preload("uid://bl74swykundp7"),
	Enums.SpriteForms.Form4: preload("uid://ccceqs3xfjypr"),
}


static func random_sprite_form() -> Enums.SpriteForms:
	var result: Enums.SpriteForms
	var index: int = randi_range(0, GAME_SPRITES.size() - 1)
	var current_index: int = 0;
	for i: Enums.SpriteForms in GAME_SPRITES.keys():
		if index == current_index:
			result = i;
			break;
		current_index += 1;
	return result
