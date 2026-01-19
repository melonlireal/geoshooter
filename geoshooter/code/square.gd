extends Enemy

const SQUSCALEFACTOR = 1

func _ready() -> void:
	self_name = "squ"
	children = preload("res://code/square.tscn")
	split_num = 4
	self.scale = Vector2(size*SQUSCALEFACTOR, size*SQUSCALEFACTOR)
	

func gets_damage(damage: int):
	super.gets_damage(damage)
	
func split():
	super.split()


func _on_timer_timeout() -> void:
	just_spawn = true
