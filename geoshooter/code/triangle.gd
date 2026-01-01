extends Enemy

const TRISCALEFACTOR = 1.5

func _ready() -> void:
	self.scale = Vector2(size*TRISCALEFACTOR, size*TRISCALEFACTOR)
	print("triangle with scale of", self.scale)
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
	
