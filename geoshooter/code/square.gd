extends Enemy


func _ready() -> void:
	$healthdisplay.text = str(health)
	
func _physics_process(_delta: float) -> void:
	var basic = Vector2(0,1)
	velocity = basic * SPEED
	move_and_slide()

func gets_damage(damage: int):
	super.gets_damage(damage)
	$healthdisplay.text = str(health)
	
func split():
	super.split()
	
