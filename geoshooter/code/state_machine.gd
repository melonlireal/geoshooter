extends Node
@export var initial_state: State
var cur_state: State
var states = {}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.transition.connect()

func _process(delta: float) -> void:
	if cur_state:
		cur_state.update(delta)
		
func _physics_process(delta: float) -> void:
	if cur_state:
		cur_state.physic_update(delta)

func on_child_transition(state: State, newstate: State):
	if state != cur_state:
		return
	var new_state = states.get(newstate.name)
	if cur_state:
		cur_state.exit()
		cur_state = newstate
