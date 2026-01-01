extends Node2D

var can_shoot = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(_delta: float) -> void:
	if Input.is_action_pressed("shoot"):
		if !can_shoot:
			return
		elif can_shoot:
			can_shoot = false
			$shoot_cooldown.start()
		var bul = preload("res://code/bullet.tscn")
		var bullet:Bullet = bul.instantiate()
		var direction: Vector2 = (get_global_mouse_position() - %player.position)
		direction = direction.normalized()
		bullet.get_direction(direction)
		bullet.position = %player.position
		self.add_child(bullet)

func add_enemy():
	var square: Enemy = preload("res://code/square.tscn").instantiate()
	var triangle: Enemy = preload("res://code/triangle.tscn").instantiate()
	var random = [square, triangle]
	var enemy: Enemy = random.pick_random()
	enemy.dead.connect(enemy_died)
	enemy.spawn_child.connect(spawn_children)
	var screen_size = get_viewport_rect().size
	enemy.position.y = -500.0
	enemy.position.x = randf_range(0, screen_size.x)
	enemy.size = randi_range(2,3)
	print(enemy.size)
	enemy.autodie_pos = screen_size + Vector2(0, 500)
	$level.add_child(enemy)
	
func enemy_died():
	$score/scoreUi.update_score(1000)
	pass
	
func spawn_children(position: Vector2, child: Enemy, raduis: int, split_num: int, size: int):
	pass
	
func _on_shoot_cooldown_timeout() -> void:
	can_shoot = true


func _on_spawn_cooldown_timeout() -> void:
	add_enemy()
