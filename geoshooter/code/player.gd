extends CharacterBody2D
class_name Player

var InputDirection:Vector2 = Vector2.ZERO
var HEALTHSCALE = 0.05
const SPEED = 600
const ACCELERATION = 30
var health = 10
@export var last_killed = ""
var pen_col: Color = Color(255, 0.0, 0.0, 1.0)
var tri_col: Color = Color(0.988, 1.0, 0.0, 1.0)
var squ_col: Color = Color(0.0, 0.847, 1.0, 1.0)
var curr_col: Color = Color(1.0, 1.0, 1.0, 1.0)
var can_shoot = true

func _input(_event: InputEvent) -> void:
	InputDirection = Input.get_vector("Left","Right","Up","Down")
	if Input.is_action_pressed("shoot"):
		if !can_shoot:
			return
		elif can_shoot:
			can_shoot = false
			$shoot_cooldown.start()
		var bul = preload("res://code/bullet.tscn")
		var bullet:Bullet = bul.instantiate()
		var direction: Vector2 = (get_global_mouse_position() - self.global_position)
		direction = direction.normalized()
		bullet.get_direction(direction)
		bullet.position = self.global_position
		bullet.last_killed = last_killed
		bullet.set_col(curr_col)
		get_parent().add_child(bullet)
		
func _physics_process(delta: float) -> void:
	if InputDirection == Vector2.ZERO:
		return
	velocity = self.velocity.lerp(InputDirection * SPEED, ACCELERATION*delta)
	move_and_slide()
	
func update_killed(killed: String):
	last_killed = killed
	if last_killed == "pentagon":
		$Sprite2D.modulate = pen_col
		curr_col = pen_col
	elif last_killed == "triangle":
		$Sprite2D.modulate = tri_col
		curr_col = tri_col
	elif last_killed == "square":
		$Sprite2D.modulate = squ_col
		curr_col = squ_col

func get_hit():
	health -= 1
	self.scale = Vector2(HEALTHSCALE * health, HEALTHSCALE * health)
	if health <= 0:
		queue_free()


func _on_shoot_cooldown_timeout() -> void:
	can_shoot = true
