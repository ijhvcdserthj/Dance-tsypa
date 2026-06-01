extends Area2D

var direction = "up"
var speed = 300
var player_id = 1  # ← ДОБАВЬ ЭТУ СТРОКУ

func _ready():
	var path = "res://assets/arrows/arrow_" + direction + ".png"
	if ResourceLoader.exists(path):
		$ArrowSprite.texture = load(path)
	else:
		$ArrowSprite.modulate = Color(0, 0, 1, 1)
		$ArrowSprite.scale = Vector2(2, 2)

func _process(delta):
	position.y += speed * delta
	if position.y > 800:
		queue_free()
