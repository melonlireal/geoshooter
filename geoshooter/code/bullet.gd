extends CharacterBody2D
class_name Bullet

const SPEED = 800
const DAMAGEBONUS = 2
@export var damage = 5
@export var last_killed = ""
var direction: Vector2
signal update_streak
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.

func get_direction(dir: Vector2):
	direction= dir

func _physics_process(delta: float) -> void:
	position += direction * SPEED * delta

func give_damage(hitobj_weak: String):
	print(hitobj_weak)
	if hitobj_weak == last_killed:
		update_streak.emit()
		return damage * DAMAGEBONUS
	return damage

func set_col(color: Color):
	$Sprite2D.modulate = color

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
