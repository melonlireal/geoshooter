extends Enemy

const PENSCALEFACTOR = 1.5

func _ready() -> void:
	self_name = "pen"
	children = preload("res://code/pentagon.tscn")
	split_num = 5
	self.scale = Vector2(size*PENSCALEFACTOR, size*PENSCALEFACTOR)
	seperate_factor = 2
	

func gets_damage(damage: int):
	super.gets_damage(damage)
	
func split():
	super.split()
