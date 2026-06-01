extends Control

func _ready():
	$EasyButton.pressed.connect(_on_easy)
	$MediumButton.pressed.connect(_on_medium)
	$HardButton.pressed.connect(_on_hard)
	$BackButton.pressed.connect(_on_back)

func _on_easy():
	GameManager.selected_difficulty = "easy"
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_medium():
	GameManager.selected_difficulty = "medium"
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_hard():
	GameManager.selected_difficulty = "hard"
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_back():
	get_tree().change_scene_to_file("res://scenes/player_select.tscn")
