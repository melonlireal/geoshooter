extends Node2D

@onready var scores = $score/UI
@onready var player = null
@onready var level = $score/level
@onready var spawn_timer = $Timers/spawn_timer
@onready var pierce_timer = $Timers/pierce_timer
@onready var rage_timer = $Timers/rage_timer
@onready var invincible_timer = $Timers/invincible_timer
var triene: int = 0
var squene: int = 0
var penene: int = 0
var maxene: int = 20
var spawn_interval = 1
var health_factor = 1
var speed_factor = 1
var max_size = 1
var start = true
var rock_tween:Tween = null
var mouseDirection:Vector2 = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_player()
	$score/UI.rock.connect(rock)
	$score/UI.end_rock.connect(end_rock)
	$score/UI.spawn_player.connect(spawn_player)
	pass # Replace with function body.

func _process(_delta: float) -> void:
	spawn_interval = 2 * (1 - min(scores.get_score()/100000.0, 0.5))
	health_factor = 1 * (1 + min(scores.get_score()/100000.0, 1))
	speed_factor = 1 * (1 + min(scores.get_score()/100000.0, 1))
	max_size = 1 + min(scores.get_score()/500000, 4)
	spawn_timer.wait_time = spawn_interval
	get_viewport().warp_mouse(get_global_mouse_position()+mouseDirection * 20)
	# dynamic difficulty reaching maximum difficulty at one million socre
	
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("pierce") and triene > 0 and squene > 0:
		player.switch_pierce_ammo()
		pierce_timer.start()
	if Input.is_action_just_pressed("rage") and squene > 0 and penene > 0:
		player.switch_rage()
		rage_timer.start()
	if Input.is_action_just_pressed("invincible") and triene >= 3 and squene >= 3 and penene >= 3:
		player.switch_invincible()
		invincible_timer.start()
	if Input.is_anything_pressed() and start:
		start = false
		spawn_timer.start()
		player.visible = true
		$score/RichTextLabel.visible = false
		$score/UI.start_game()
	mouseDirection = Input.get_vector("controller_move_mouse_left", "controller_move_mouse_right", "controller_move_mouse_up", "controller_move_mouse_down")
	
	
func spawn_player():
	var play:PackedScene = ResourceLoader.load("res://code/player.tscn")
	var player_ready:Player = play.instantiate()
	player_ready.position = Vector2(530, 296)
	player_ready.scale = Vector2(0.5,0.5)
	player_ready.visible = true
	$score/level.add_child(player_ready)
	player_ready.player_dead.connect(game_over)
	player_ready.decrease_fac.connect(decrease_score_factor)
	player = player_ready
	
func rock():
	if rock_tween:
		return
	rock_tween = create_tween()
	rock_tween.tween_property($score/ColorRect, "color", Color(0.809, 0.809, 0.809, 1.0), 0.2)
	#$score/ColorRect.color = Color(0.809, 0.809, 0.809, 1.0)
	$score/ColorRect/GPUParticles2D.lifetime = 3.0
	await rock_tween.finished
	rock_tween.kill()
	rock_tween = null
	
func end_rock():
	if rock_tween:
		return
	rock_tween = create_tween()
	rock_tween.tween_property($score/ColorRect, "color", Color(0.137, 0.137, 0.137, 1.0), 0.2)
	$score/ColorRect/GPUParticles2D.lifetime = 30.0
	await rock_tween.finished
	rock_tween.kill()
	rock_tween = null
	
func enemy_died(dead_name: String):
	match dead_name:
		"tri":
			triene += 1
		"squ":
			squene += 1
		"pen":
			penene += 1
	scores.update_energy(triene, squene, penene)
	pass
	
func game_over():
	$score/UI.end_game()
	pass



func add_score(score: int):
	scores.update_score(score)
	if player != null:
		scores.update_progress_bar(player.health)
		
func decrease_score_factor():
	scores.reset_factor()
	
	
	
func add_enemy():
	var square: PackedScene = preload("res://code/square.tscn")
	var triangle: PackedScene = preload("res://code/triangle.tscn")
	var pentagon: PackedScene = preload("res://code/pentagon.tscn")
	var random = [triangle,square,pentagon]
	var rand_ene: PackedScene = random.pick_random()
	var screen_size = get_viewport_rect().size
	var enemy_size = randi_range(2,max_size)
	var temp_enemy = rand_ene.instantiate()
	temp_enemy.size = enemy_size
	level.add_child(temp_enemy)
	temp_enemy.queue_free()
	var min_x = 0
	var max_x = screen_size.x 
	# Create spawn position
	var spawn_pos: Vector2
	spawn_pos = Vector2(randf_range(min_x, max_x), -300)
	spawn_children(spawn_pos, rand_ene, 1, enemy_size)
	
func spawn_children(pos: Vector2, child: PackedScene, split_num: int, size: int):
	if $score/level.get_child_count() > 300:
		#print("hell nah")
		return
	var angle_step = 2 * PI / split_num
	var tween: Tween = create_tween()
	tween.set_parallel()
	for i in range(split_num):
		var new_enemy: Enemy = child.instantiate()
		var radius = 70 * size * new_enemy.seperate_factor
		var angle = angle_step * i
		var offset = Vector2(cos(angle), sin(angle)) * radius
		if split_num == 1:
			offset = Vector2.ZERO
		var spawn_pos = pos + offset
		new_enemy.position = pos
		new_enemy.size = size
		var rand_health = randi_range(8,12) * health_factor
		new_enemy.set_health(rand_health * size)
		var rand_score = randi_range(6,14)
		new_enemy.score = rand_score * size
		var rand_speed = randi_range(50,70) * speed_factor
		new_enemy.SPEED = rand_speed
		new_enemy.dead.connect(enemy_died)
		new_enemy.spawn_child.connect(spawn_children)
		new_enemy.update_score.connect(add_score)
		new_enemy.autodie_pos = get_viewport_rect().size + Vector2(0, 500)
		level.call_deferred("add_child", new_enemy)
		tween.tween_property(new_enemy, "position", spawn_pos, 0.1)
		
		
		

func _on_spawn_timer_timeout() -> void:
	add_enemy()

func _on_pierce_timer_timeout() -> void:
	triene -= 1
	squene -= 1
	scores.update_energy(triene, squene, penene)
	if triene<= 0 or squene <= 0:
		if player != null:
			player.end_pierce_ammo()
			pierce_timer.stop()
			
func _on_rage_timer_timeout() -> void:
	#print("consume energy")
	squene -= 1
	penene -= 1
	scores.update_energy(triene, squene, penene)
	if squene<= 0 or penene <= 0:
		if player != null:
			player.end_rage()
			rage_timer.stop()


func _on_invincible_timer_timeout() -> void:
	#print("consume energy")
	triene -= 3
	squene -= 3
	penene -= 3
	scores.update_energy(triene, squene, penene)
	if triene <= 0 or squene <= 0 or penene <= 0:
		if player != null:
			player.end_invincible()
			invincible_timer.stop()
	pass # Replace with function body.
