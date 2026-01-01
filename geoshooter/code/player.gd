extends CharacterBody2D


var InputDirection:Vector2 = Vector2.ZERO
const SPEED = 600
const ACCELERATION = 30

func _input(_event: InputEvent) -> void:
	InputDirection = Input.get_vector("Left","Right","Up","Down")
		
		
	
func _physics_process(delta: float) -> void:
	if InputDirection == Vector2.ZERO:
		return
	velocity = self.velocity.lerp(InputDirection * SPEED, ACCELERATION*delta)
	move_and_slide()
