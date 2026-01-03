extends Node2D

var last_death = ""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func add_enemy():
	var square: PackedScene = preload("res://code/square.tscn")
	var triangle: PackedScene = preload("res://code/triangle.tscn")
	var pentagon: PackedScene = preload("res://code/pentagon.tscn")
	var random = [square, triangle, pentagon]
	var rand_ene: PackedScene = random.pick_random()
	var enemy: Enemy = rand_ene.instantiate()
	enemy.dead.connect(enemy_died)
	enemy.spawn_child.connect(spawn_children)
	var screen_size = get_viewport_rect().size
	enemy.position.y = -500.0
	enemy.position.x = randf_range(0, screen_size.x)
	enemy.size = randi_range(2,3)
	enemy.autodie_pos = screen_size + Vector2(0, 500)
	$level.add_child(enemy)
	
func enemy_died(dead_name: String):
	print(dead_name, " is dead！")
	last_death = dead_name
	$score/scoreUi.update_score(10)
	%player.update_killed(dead_name)
	pass
	
func spawn_children(position: Vector2, child: PackedScene, raduis: int, split_num: int, size: int):
	var new_enemy: Enemy = child.instantiate()
	new_enemy.position = position
	new_enemy.size = size
	new_enemy.dead.connect(enemy_died)
	new_enemy.spawn_child.connect(spawn_children)
	new_enemy.autodie_pos = get_viewport_rect().size + Vector2(0, 500)
	$level.add_child(new_enemy)
	


func _on_spawn_cooldown_timeout() -> void:
	add_enemy()
