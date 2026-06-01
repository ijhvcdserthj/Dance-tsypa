extends Control

func _ready():
	$PlayButton.pressed.connect(_on_play)
	$QuitButton.pressed.connect(_on_quit)

func _on_play():
	get_tree().change_scene_to_file("res://scenes/player_select.tscn")

func _on_quit():
	get_tree().quit()
