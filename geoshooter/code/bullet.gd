extends CharacterBody2D
class_name Bullet

const SPEED = 1200
@export var damage = 10
@export var damagebonus = 2
@export var pierce_num = 0
var direction: Vector2 = Vector2.ONE
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if pierce_num > 0:
		$spirtes/normal.visible = false
		$spirtes/pierce.visible = true
		$tail.visible = true
	pass # Replace with function body.

func get_direction(dir: Vector2):
	direction= dir

func _physics_process(delta: float) -> void:
	position += direction * SPEED * delta

func give_damage():
	return damage

func set_col(color: Color):
	self.modulate = color

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
	
func emit_particle():
	$GPUParticles2D.emitting = true
	if pierce_num == 0:
		$spirtes.queue_free()
		$CollisionShape2D.queue_free()
		$particle_timer.start()
		set_physics_process(false)
	else:
		pierce_num -= 1


func _on_particle_timer_timeout() -> void:
	if pierce_num == 0:
		queue_free()
