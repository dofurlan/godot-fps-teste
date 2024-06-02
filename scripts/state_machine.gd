class_name StateMachine
extends Node

@export var CURRENT_STATE : state
var states:Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if not child is state:
			push_warning('Node %s is not a state1' % child.name)
			continue
		
		states[child.name.to_lower()] = child
		child.transition.connect(on_child_transition)
		
	CURRENT_STATE.enter()
	
	print(states)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	CURRENT_STATE.update(delta)
	
func _physics_process(delta):
	CURRENT_STATE.physics_update(delta)
	
func on_child_transition(new_state_name:StringName) -> void:
	var new_state:state = states.get(new_state_name.to_lower())
	
	if new_state == null:
		push_warning('State %s not found as child!' % new_state_name)
		return
		
	if new_state == CURRENT_STATE:
		return
	
	print('Changing from %s to %s' % [CURRENT_STATE.name, new_state_name])
	
	CURRENT_STATE.exit()
	CURRENT_STATE = new_state
	CURRENT_STATE.enter()
	

