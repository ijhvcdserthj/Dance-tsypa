extends Node2D

# переменные игры
var note_speed = 300
var spawn_delay = 1.2
var notes_player1 = []
var notes_player2 = []
var score_player1 = 0
var score_player2 = 0
var game_active = true
var both_players = false

# анимация жёлтого
var dance_frames_yellow = []
var is_dancing_yellow = false
var dance_timer_yellow = null
var current_frame_yellow = 0

# анимация серого
var dance_frames_gray = []
var is_dancing_gray = false
var dance_timer_gray = null
var current_frame_gray = 0

# зона попадания
var hit_zone_y = 300
var good_tolerance = 40
var music_player = null

# запускается при открытии сцены, настраивает всё для игры
func _ready():
	both_players = (GameManager.players_count == 2)
	load_animations()
	setup_visibility()
	setup_music()
	setup_background()
	setup_difficulty()
	setup_timers()
	$MenuButton.pressed.connect(_on_menu)
	update_scores()

# загружает картинки для анимации танца и обычные картинки для жёлтого и серого
func load_animations():
	var diff = GameManager.selected_difficulty
	
	dance_frames_yellow = []
	if diff == "easy":
		for i in range(6):
			var path = "res://assets/tsypa/easy/yellow_dance_" + str(i) + ".png"
			if ResourceLoader.exists(path):
				dance_frames_yellow.append(load(path))
			else:
				var img = Image.create(64, 64, false, Image.FORMAT_RGBA8)
				img.fill(Color(1, 0.5, 0.5))
				dance_frames_yellow.append(ImageTexture.create_from_image(img))
		var idle_path = "res://assets/tsypa/easy/yellow_idle.png"
		if ResourceLoader.exists(idle_path):
			$TsypaYellow.texture = load(idle_path)
		else:
			var img = Image.create(64, 64, false, Image.FORMAT_RGBA8)
			img.fill(Color(1, 0.8, 0))
			$TsypaYellow.texture = ImageTexture.create_from_image(img)
	
	elif diff == "medium":
		for i in range(1, 7):
			var path = "res://assets/tsypa/medium/zhelty_tsypa" + str(i) + "-3.png"
			if ResourceLoader.exists(path):
				dance_frames_yellow.append(load(path))
			else:
				var img = Image.create(64, 64, false, Image.FORMAT_RGBA8)
				img.fill(Color(1, 0.5, 0.5))
				dance_frames_yellow.append(ImageTexture.create_from_image(img))
		var idle_path = "res://assets/tsypa/medium/zhts_bit_it_sed4.png"
		if ResourceLoader.exists(idle_path):
			$TsypaYellow.texture = load(idle_path)
		else:
			var img = Image.create(64, 64, false, Image.FORMAT_RGBA8)
			img.fill(Color(1, 0.8, 0))
			$TsypaYellow.texture = ImageTexture.create_from_image(img)
	
	else:
		for i in range(1, 7):
			var path = "res://assets/tsypa/hard/zhelty_tsypa" + str(i) + "-2.png"
			if ResourceLoader.exists(path):
				dance_frames_yellow.append(load(path))
			else:
				var img = Image.create(64, 64, false, Image.FORMAT_RGBA8)
				img.fill(Color(1, 0.5, 0.5))
				dance_frames_yellow.append(ImageTexture.create_from_image(img))
		var idle_path = "res://assets/tsypa/hard/zhts_toxik_sed4.png"
		if ResourceLoader.exists(idle_path):
			$TsypaYellow.texture = load(idle_path)
		else:
			var img = Image.create(64, 64, false, Image.FORMAT_RGBA8)
			img.fill(Color(1, 0.8, 0))
			$TsypaYellow.texture = ImageTexture.create_from_image(img)
	
	if both_players:
		dance_frames_gray = []
		if diff == "easy":
			for i in range(1, 7):
				var path = "res://assets/tsypa/easy/sery_tsypa" + str(i) + "-2.png"
				if ResourceLoader.exists(path):
					dance_frames_gray.append(load(path))
				else:
					var img = Image.create(64, 64, false, Image.FORMAT_RGBA8)
					img.fill(Color(0.5, 0.5, 0.5))
					dance_frames_gray.append(ImageTexture.create_from_image(img))
			var idle_path = "res://assets/tsypa/easy/sts_balet_sed4.png"
			if ResourceLoader.exists(idle_path):
				$TsypaGray.texture = load(idle_path)
			else:
				var img = Image.create(64, 64, false, Image.FORMAT_RGBA8)
				img.fill(Color(0.6, 0.6, 0.6))
				$TsypaGray.texture = ImageTexture.create_from_image(img)
		
		elif diff == "medium":
			for i in range(1, 7):
				var path = "res://assets/tsypa/medium/sery_tsypa" + str(i) + ".png"
				if ResourceLoader.exists(path):
					dance_frames_gray.append(load(path))
				else:
					var img = Image.create(64, 64, false, Image.FORMAT_RGBA8)
					img.fill(Color(0.5, 0.5, 0.5))
					dance_frames_gray.append(ImageTexture.create_from_image(img))
			var idle_path = "res://assets/tsypa/medium/sts_balet_sed4.png"
			if ResourceLoader.exists(idle_path):
				$TsypaGray.texture = load(idle_path)
			else:
				var img = Image.create(64, 64, false, Image.FORMAT_RGBA8)
				img.fill(Color(0.6, 0.6, 0.6))
				$TsypaGray.texture = ImageTexture.create_from_image(img)
		
		else:
			for i in range(1, 7):
				var path = "res://assets/tsypa/hard/sery_tsypa" + str(i) + "-3.png"
				if ResourceLoader.exists(path):
					dance_frames_gray.append(load(path))
				else:
					var img = Image.create(64, 64, false, Image.FORMAT_RGBA8)
					img.fill(Color(0.5, 0.5, 0.5))
					dance_frames_gray.append(ImageTexture.create_from_image(img))
			var idle_path = "res://assets/tsypa/hard/sts_toxik_sed4.png"
			if ResourceLoader.exists(idle_path):
				$TsypaGray.texture = load(idle_path)
			else:
				var img = Image.create(64, 64, false, Image.FORMAT_RGBA8)
				img.fill(Color(0.6, 0.6, 0.6))
				$TsypaGray.texture = ImageTexture.create_from_image(img)

# настраивает видимость: для 1 игрока скрывает серую цыпу и всё с ней связанное
func setup_visibility():
	if not both_players:
		$TsypaGray.visible = false
		if has_node("HitZoneP2_Up"): $HitZoneP2_Up.visible = false
		if has_node("HitZoneP2_Down"): $HitZoneP2_Down.visible = false
		if has_node("HitZoneP2_Left"): $HitZoneP2_Left.visible = false
		if has_node("HitZoneP2_Right"): $HitZoneP2_Right.visible = false
		if has_node("HitZoneP2_Up2"): $HitZoneP2_Up2.visible = false
		if has_node("HitZoneP2_Down2"): $HitZoneP2_Down2.visible = false
		if has_node("HitZoneP2_Left2"): $HitZoneP2_Left2.visible = false
		if has_node("HitZoneP2_Right2"): $HitZoneP2_Right2.visible = false
		if has_node("ScoreLabelPlayer2"): $ScoreLabelPlayer2.visible = false
		if has_node("SpawnTimerP2"): $SpawnTimerP2.stop()
		if has_node("ScoreLabelPlayer1"):
			$ScoreLabelPlayer1.position = Vector2(284, 589)
			$ScoreLabelPlayer1.text = "Счёт: 0"
	else:
		$TsypaGray.visible = true
		if has_node("HitZoneP2_Up"): $HitZoneP2_Up.visible = true
		if has_node("HitZoneP2_Down"): $HitZoneP2_Down.visible = true
		if has_node("HitZoneP2_Left"): $HitZoneP2_Left.visible = true
		if has_node("HitZoneP2_Right"): $HitZoneP2_Right.visible = true
		if has_node("HitZoneP2_Up2"): $HitZoneP2_Up2.visible = true
		if has_node("HitZoneP2_Down2"): $HitZoneP2_Down2.visible = true
		if has_node("HitZoneP2_Left2"): $HitZoneP2_Left2.visible = true
		if has_node("HitZoneP2_Right2"): $HitZoneP2_Right2.visible = true
		if has_node("ScoreLabelPlayer2"):
			$ScoreLabelPlayer2.visible = true
			$ScoreLabelPlayer2.position = Vector2(785, 589)
			$ScoreLabelPlayer2.text = "Счёт: 0"
		if has_node("SpawnTimerP2"): $SpawnTimerP2.start()
		if has_node("ScoreLabelPlayer1"):
			$ScoreLabelPlayer1.position = Vector2(284, 589)
			$ScoreLabelPlayer1.text = "Счёт: 0"

# запускает музыку в зависимости от выбранной сложности
func setup_music():
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	var music_path = ""
	match GameManager.selected_difficulty:
		"easy": music_path = "res://assets/music/easy_music.ogg"
		"medium": music_path = "res://assets/music/medium_music.ogg"
		"hard": music_path = "res://assets/music/hard_music.ogg"
	if ResourceLoader.exists(music_path):
		var stream = load(music_path)
		music_player.stream = stream
		music_player.play()
		var duration = stream.get_length()
		await get_tree().create_timer(duration).timeout
		end_game()
	else:
		await get_tree().create_timer(30.0).timeout
		end_game()

# завершает игру, останавливает всё и показывает результат
func end_game():
	if not game_active:
		return
	game_active = false
	if has_node("SpawnTimerP1"): $SpawnTimerP1.stop()
	if has_node("SpawnTimerP2"): $SpawnTimerP2.stop()
	if music_player: music_player.stop()
	show_final_score()

# показывает экран с финальными очками и победителем
func show_final_score():
	var panel = ColorRect.new()
	panel.color = Color(0, 0, 0, 0.8)
	panel.size = Vector2(600, 350)
	panel.position = Vector2(276, 150)
	add_child(panel)
	var title = Label.new()
	title.text = "ИГРА ОКОНЧЕНА"
	title.add_theme_color_override("font_color", Color(1, 0.8, 0))
	title.add_theme_font_size_override("font_size", 40)
	title.position = Vector2(400, 180)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(title)
	if both_players:
		var p1 = Label.new()
		p1.text = "ЖЁЛТЫЙ: " + str(score_player1)
		p1.add_theme_color_override("font_color", Color(1, 0.8, 0))
		p1.add_theme_font_size_override("font_size", 30)
		p1.position = Vector2(400, 250)
		p1.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		add_child(p1)
		var p2 = Label.new()
		p2.text = "СЕРЫЙ: " + str(score_player2)
		p2.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
		p2.add_theme_font_size_override("font_size", 30)
		p2.position = Vector2(400, 290)
		p2.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		add_child(p2)
		var winner = "ЖЁЛТЫЙ" if score_player1 > score_player2 else "СЕРЫЙ" if score_player2 > score_player1 else "НИЧЬЯ"
		var w = Label.new()
		w.text = "ПОБЕДИТЕЛЬ: " + winner
		w.add_theme_color_override("font_color", Color(0, 1, 0))
		w.add_theme_font_size_override("font_size", 30)
		w.position = Vector2(400, 330)
		w.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		add_child(w)
	else:
		var score_label = Label.new()
		score_label.text = "ТВОЙ СЧЁТ: " + str(score_player1)
		score_label.add_theme_color_override("font_color", Color(1, 1, 1))
		score_label.add_theme_font_size_override("font_size", 50)
		score_label.position = Vector2(400, 260)
		score_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		add_child(score_label)
	var btn = Button.new()
	btn.text = "В ГЛАВНОЕ МЕНЮ"
	btn.position = Vector2(400, 400)
	btn.size = Vector2(250, 50)
	btn.pressed.connect(_on_menu)
	add_child(btn)

# загружает фон в зависимости от выбранной сложности
func setup_background():
	var path = "res://assets/backgrounds/bg_" + GameManager.selected_difficulty + ".png"
	if ResourceLoader.exists(path):
		$Background.texture = load(path)
		$Background.stretch_mode = 4

# настраивает скорость стрелок и частоту их появления в зависимости от сложности
func setup_difficulty():
	match GameManager.selected_difficulty:
		"easy":
			note_speed = 200
			spawn_delay = 1.2
		"medium":
			note_speed = 300
			spawn_delay = 0.8
		"hard":
			note_speed = 400
			spawn_delay = 0.5
	if has_node("SpawnTimerP1"):
		$SpawnTimerP1.wait_time = spawn_delay

# запускает таймеры для создания стрелок
func setup_timers():
	if has_node("SpawnTimerP1"):
		$SpawnTimerP1.timeout.connect(_on_spawn_p1)
		$SpawnTimerP1.start()
	if both_players and has_node("SpawnTimerP2"):
		$SpawnTimerP2.timeout.connect(_on_spawn_p2)
		$SpawnTimerP2.wait_time = spawn_delay
		$SpawnTimerP2.start()

# обновляет текст со счётом на экране
func update_scores():
	if has_node("ScoreLabelPlayer1"):
		$ScoreLabelPlayer1.text = "Счёт: " + str(score_player1)
	if both_players and has_node("ScoreLabelPlayer2"):
		$ScoreLabelPlayer2.text = "Счёт: " + str(score_player2)

# вызывается по таймеру, создаёт новую стрелку для игрока 1
func _on_spawn_p1():
	if game_active:
		spawn_note(1)

# вызывается по таймеру, создаёт новую стрелку для игрока 2
func _on_spawn_p2():
	if game_active and both_players:
		spawn_note(2)

# создаёт одну падающую стрелку для указанного игрока
func spawn_note(player):
	var dirs = ["up", "down", "left", "right"]
	var dir = dirs[randi() % dirs.size()]
	var x_pos = {
		1: {"up": 105, "down": 319, "left": 209, "right": 433},
		2: {"up": 645, "down": 865, "left": 756, "right": 963}
	}
	var note = preload("res://scenes/note.tscn").instantiate()
	note.direction = dir
	note.speed = note_speed
	note.position = Vector2(x_pos[player][dir], 50)
	note.player_id = player
	add_child(note)
	if player == 1:
		notes_player1.append(note)
	else:
		notes_player2.append(note)

# запускает анимацию танца для указанного игрока
func start_dance(player):
	if player == 1:
		if is_dancing_yellow:
			return
		is_dancing_yellow = true
		current_frame_yellow = 0
		$TsypaYellow.texture = dance_frames_yellow[0]
		dance_timer_yellow = Timer.new()
		dance_timer_yellow.wait_time = 0.1
		dance_timer_yellow.timeout.connect(_on_dance_yellow)
		dance_timer_yellow.one_shot = false
		add_child(dance_timer_yellow)
		dance_timer_yellow.start()
	else:
		if is_dancing_gray:
			return
		is_dancing_gray = true
		current_frame_gray = 0
		$TsypaGray.texture = dance_frames_gray[0]
		dance_timer_gray = Timer.new()
		dance_timer_gray.wait_time = 0.1
		dance_timer_gray.timeout.connect(_on_dance_gray)
		dance_timer_gray.one_shot = false
		add_child(dance_timer_gray)
		dance_timer_gray.start()

# переключает кадры анимации для жёлтого
func _on_dance_yellow():
	current_frame_yellow += 1
	if current_frame_yellow >= dance_frames_yellow.size():
		current_frame_yellow = 0
	$TsypaYellow.texture = dance_frames_yellow[current_frame_yellow]

# переключает кадры анимации для серого
func _on_dance_gray():
	current_frame_gray += 1
	if current_frame_gray >= dance_frames_gray.size():
		current_frame_gray = 0
	$TsypaGray.texture = dance_frames_gray[current_frame_gray]

# останавливает анимацию и возвращает обычную картинку для указанного игрока
func stop_dance(player):
	var diff = GameManager.selected_difficulty
	if player == 1:
		if not is_dancing_yellow:
			return
		is_dancing_yellow = false
		if dance_timer_yellow:
			dance_timer_yellow.stop()
			dance_timer_yellow.queue_free()
			dance_timer_yellow = null
		var idle_path = ""
		if diff == "easy":
			idle_path = "res://assets/tsypa/easy/yellow_idle.png"
		elif diff == "medium":
			idle_path = "res://assets/tsypa/medium/zhts_bit_it_sed4.png"
		else:
			idle_path = "res://assets/tsypa/hard/zhts_toxik_sed4.png"
		if ResourceLoader.exists(idle_path):
			$TsypaYellow.texture = load(idle_path)
		else:
			var img = Image.create(64, 64, false, Image.FORMAT_RGBA8)
			img.fill(Color(1, 0.8, 0))
			$TsypaYellow.texture = ImageTexture.create_from_image(img)
	else:
		if not is_dancing_gray:
			return
		is_dancing_gray = false
		if dance_timer_gray:
			dance_timer_gray.stop()
			dance_timer_gray.queue_free()
			dance_timer_gray = null
		var idle_path = ""
		if diff == "easy":
			idle_path = "res://assets/tsypa/easy/sts_balet_sed4.png"
		elif diff == "medium":
			idle_path = "res://assets/tsypa/medium/sts_balet_sed4.png"
		else:
			idle_path = "res://assets/tsypa/hard/sts_toxik_sed4.png"
		if ResourceLoader.exists(idle_path):
			$TsypaGray.texture = load(idle_path)
		else:
			var img = Image.create(64, 64, false, Image.FORMAT_RGBA8)
			img.fill(Color(0.6, 0.6, 0.6))
			$TsypaGray.texture = ImageTexture.create_from_image(img)

# проверяет, попал ли игрок по стрелке, начисляет очки и запускает танец
func check_hit(player, direction):
	var notes_arr = notes_player1 if player == 1 else notes_player2
	for i in range(notes_arr.size() - 1, -1, -1):
		var note = notes_arr[i]
		if note.direction == direction:
			var y = note.position.y
			if y > hit_zone_y:
				note.queue_free()
				notes_arr.remove_at(i)
				if (player == 1 and is_dancing_yellow) or (player == 2 and is_dancing_gray):
					stop_dance(player)
				return
			var distance = hit_zone_y - y
			if distance <= good_tolerance:
				note.queue_free()
				notes_arr.remove_at(i)
				if player == 1:
					score_player1 += 1
				else:
					score_player2 += 1
				update_scores()
				start_dance(player)
				return
			else:
				if (player == 1 and is_dancing_yellow) or (player == 2 and is_dancing_gray):
					stop_dance(player)
				return

# проверяет, не пролетели ли стрелки мимо зоны попадания, если да - останавливает танец
func check_missed():
	for i in range(notes_player1.size() - 1, -1, -1):
		if notes_player1[i].position.y > hit_zone_y + 20:
			notes_player1[i].queue_free()
			notes_player1.remove_at(i)
			if is_dancing_yellow:
				stop_dance(1)
	if both_players:
		for i in range(notes_player2.size() - 1, -1, -1):
			if notes_player2[i].position.y > hit_zone_y + 20:
				notes_player2[i].queue_free()
				notes_player2.remove_at(i)
				if is_dancing_gray:
					stop_dance(2)

# вызывается каждый кадр для проверки пролетевших стрелок
func _process(_delta):
	check_missed()

# обрабатывает нажатия клавиш
func _input(event):
	if event is InputEventKey and event.pressed:
		var dir1 = ""
		match event.keycode:
			KEY_W: dir1 = "up"
			KEY_S: dir1 = "down"
			KEY_A: dir1 = "left"
			KEY_D: dir1 = "right"
		var dir2 = ""
		if both_players:
			match event.keycode:
				KEY_UP: dir2 = "up"
				KEY_DOWN: dir2 = "down"
				KEY_LEFT: dir2 = "left"
				KEY_RIGHT: dir2 = "right"
		if dir1 != "":
			check_hit(1, dir1)
		if both_players and dir2 != "":
			check_hit(2, dir2)

# возвращает в главное меню
func _on_menu():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
