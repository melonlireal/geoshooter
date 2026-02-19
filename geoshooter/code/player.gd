extends CharacterBody2D
class_name Player

var InputDirection:Vector2 = Vector2.ZERO
var HEALTHSCALE = 0.05
var SPEED = 600
const ACCELERATION = 30
var health = 10
var pen_col: Color = Color(255, 0.0, 0.0, 1.0)
var tri_col: Color = Color(0.988, 1.0, 0.0, 1.0)
var squ_col: Color = Color(0.0, 0.847, 1.0, 1.0)
var curr_col: Color = Color(1.0, 1.0, 1.0, 1.0)
var def_col: Color = Color(1.0, 1.0, 1.0, 1.0)
var can_shoot = true

var pierce = false
var max_pierce = 0

var rage = false
var rage_factor = 1

var invincible = false

signal decrease_fac
signal player_dead

func _process(_delta: float) -> void:
	$Sprite2D.modulate = curr_col
	if not is_inside_tree():
		return
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
		bullet.rotation = direction.angle() + PI/2
		bullet.get_direction(direction)
		bullet.position = self.global_position
		bullet.set_col(curr_col)
		bullet.damage = randi_range(6,10)
		if pierce:
			bullet.pierce_num = max_pierce
			max_pierce += 1
		if rage:
			bullet.damage = bullet.damage * (1 + log(rage_factor))
			rage_factor += 0.2
		get_parent().add_child(bullet)
		
func _input(_event: InputEvent) -> void:
	InputDirection = Input.get_vector("Left","Right","Up","Down")
		
func _physics_process(delta: float) -> void:
	if InputDirection == Vector2.ZERO:
		return
	velocity = self.velocity.lerp(InputDirection * SPEED, ACCELERATION*delta)
	move_and_slide()
	

func get_hit():
	health -= 1
	decrease_fac.emit()
	self.scale = Vector2(HEALTHSCALE * health, HEALTHSCALE * health)
	if health <= 0:
		$Sprite2D.visible = false
		$CollisionShape2D.disabled = true	
		$sfxs/dead.play()
		player_dead.emit()
		return
	$sfxs/get_hit.play()

func switch_pierce_ammo():
	curr_col = tri_col
	pierce = true
	max_pierce = 2
	
func end_pierce_ammo():
	curr_col = def_col
	pierce = false
	max_pierce = 0
	
func switch_rage():
	curr_col = pen_col
	rage = true
	
func end_rage():
	curr_col = def_col
	rage = false
	rage_factor = 2
	
func switch_invincible():
	#print("invincible on!")
	invincible = true
	SPEED = SPEED * 2
	
func end_invincible():
	invincible = false
	SPEED = SPEED/2
	
	
func _on_shoot_cooldown_timeout() -> void:
	can_shoot = true

func _on_dead_finished() -> void:
	queue_free()
