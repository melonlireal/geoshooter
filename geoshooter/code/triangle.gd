extends Enemy

const TRISCALEFACTOR = 1.5

func _ready() -> void:
	self_name = "triangle"
	weak_at = "square"
	children = preload("res://code/triangle.tscn")
	self.scale = Vector2(size*TRISCALEFACTOR, size*TRISCALEFACTOR)
	$healthdisplay.text = str(health)
	
func _physics_process(delta: float) -> void:
	var basic = Vector2(0,1)
	position += basic * SPEED * delta

func gets_damage(damage: int):
	super.gets_damage(damage)
	$healthdisplay.text = str(health)
	
func split():
	super.split()
	
