extends Control

func _ready():
	$OnePlayerButton.pressed.connect(_on_one_player)
	$TwoPlayerButton.pressed.connect(_on_two_players)
	$BackButton.pressed.connect(_on_back)

func _on_one_player():
	GameManager.players_count = 1
	get_tree().change_scene_to_file("res://scenes/level_select.tscn")

func _on_two_players():
	GameManager.players_count = 2
	get_tree().change_scene_to_file("res://scenes/level_select.tscn")

func _on_back():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
