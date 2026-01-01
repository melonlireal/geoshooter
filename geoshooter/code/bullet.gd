extends Area2D
class_name Bullet

const SPEED = 800
@export var damage = 5
var direction: Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func get_direction(dir: Vector2):
	direction= dir

func _physics_process(delta: float) -> void:
	position += direction * SPEED * delta

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()


func _on_body_shape_entered(_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	print("shape enters")
	if body.is_in_group("enemy"):
		body.gets_damage(damage)
		queue_free()
