extends Area2D

class_name Enemy
@export var size = 1.0
@export var health = 10
@export var split_num = 2
@export var SPEED = 100
var children: PackedScene = null
var radius = 0
var autodie_pos: Vector2
var self_name = ""
var weak_at = ""
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
		dead.emit(self_name)
		queue_free()
	else:
		dead.emit(self_name)
		spawn_child.emit(self.global_position,children, radius, split_num, size - 1)
		queue_free()

func action_before_death():
	pass
	
func _on_body_entered(body: Node2D) -> void:
	if body is Bullet:
		var bullet: Bullet = body
		gets_damage(bullet.give_damage(weak_at))
		body.queue_free()
		return
	elif body is Player:
		body.get_hit()
		queue_free()
