extends Enemy

const TRISCALEFACTOR = 1.5

func _ready() -> void:
	self_name = "tri"
	children = preload("res://code/triangle.tscn")
	split_num = 3
	self.scale = Vector2(size*TRISCALEFACTOR, size*TRISCALEFACTOR)

func gets_damage(damage: int):
	super.gets_damage(damage)
	
func split():
	super.split()
