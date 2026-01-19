extends Area2D

class_name Enemy
@export var size = 1.0
@export var fullhealth = 10.0
@export var health = 10.0
@export var split_num = 2
@export var SPEED = 50
@export var score = 0
var children: PackedScene = null
var radius = 0
var autodie_pos: Vector2
var self_name = ""
var just_spawn = true
var seperate_factor = 1
signal dead
signal spawn_child
signal update_score


func _process(_delta: float) -> void:
	if self.position.y >= autodie_pos.y:
		queue_free()

func _physics_process(delta: float) -> void:
	var basic = Vector2(0,1)
	position += basic * SPEED * delta
	
func gets_damage(damage: int):
	health -= damage
	var tween: Tween = create_tween()
	tween.tween_property($health, "scale", Vector2(health/fullhealth,health/fullhealth) * 0.2, 0.1)
	if health <= 0:
		split()

func set_health(health_amount: int):
	health = float(health_amount)
	fullhealth = float(health_amount)
	
func split():
	update_score.emit(score)
	if size == 1:
		action_before_death()
		dead.emit(self_name)
		ready_to_die()
	else:
		spawn_child.emit(self.global_position,children, split_num, size - 1)
		ready_to_die()

func action_before_death():
	pass
	
func get_radius() -> float:
	var sprite = $Sprite2D
	var texture_size = sprite.texture.get_size()
	var scaled_width = texture_size.x * sprite.scale.x
	var base_radius = scaled_width/ 2.0
	return base_radius * self.size 
	
	
func _on_body_entered(body: Node2D) -> void:
	if body is Bullet:
		var bullet: Bullet = body
		gets_damage(bullet.give_damage())
		body.emit_particle()
		$music/AudioStreamPlayer.play()
		return
	elif body is Player:
		if body.invincible:
			$music/AudioStreamPlayer.play()
			split()
			return
		elif just_spawn:
			queue_free()
			return
		body.get_hit()
		ready_to_die()
		

func _on_timer_timeout() -> void:
	just_spawn = false
	
func ready_to_die():
	$dead_particle.emitting = true
	$dead_timer.start()
	$Sprite2D.queue_free()
	self.find_child("collision").queue_free()
	$health.queue_free()
	
func _on_dead_timer_timeout() -> void:
	queue_free()
