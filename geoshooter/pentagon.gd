extends Enemy

const PENSCALEFACTOR = 1.5

func _ready() -> void:
	self_name = "pentagon"
	weak_at = "triangle"
	children = preload("res://code/pentagon.tscn")
	self.scale = Vector2(size*PENSCALEFACTOR, size*PENSCALEFACTOR)
	$healthdisplay.text = str(health)
	
func _physics_process(delta: float) -> void:
	var basic = Vector2(0,1)
	position += basic * SPEED * delta

func gets_damage(damage: int):
	super.gets_damage(damage)
	$healthdisplay.text = str(health)
	
func split():
	super.split()
