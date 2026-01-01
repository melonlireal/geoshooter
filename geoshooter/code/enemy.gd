extends CharacterBody2D

class_name Enemy
@export var size = 1
@export var health = 10
@export var split_num = 2
@export var SPEED = 100
var children: Enemy = null
var radius = 0
var autodie_pos: Vector2
signal dead
signal spawn_child


func _process(_delta: float) -> void:
	if self.position.y >= autodie_pos.y:
		queue_free()
	
func gets_damage(damage: int):
	health -= damage
	if health <= 0:
		split()

func split():
	if size == 1:
		action_before_death()
		dead.emit()
		queue_free()
	else:
		spawn_child.emit(self.position, children, radius, split_num, size - 1)
		queue_free()

func action_before_death():
	pass
