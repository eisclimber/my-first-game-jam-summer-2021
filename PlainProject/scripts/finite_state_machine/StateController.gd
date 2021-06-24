extends Node
class_name StateController

signal state_changed(current_state)

# Entry state of the FSM
export(NodePath) var start_state

# A mapping of state ids and their node paths.
# (E.g. {"state": $State, ...})
# The ids will be used to change states, the id "previous" is reserved
var states_map : Dictionary = {}
# Stacks of states can be resumed to
var states_stack : Array = []
# Currently processing state
var current_state : State = null
# De-/Activates processing of the FSM
var active : bool = false setget set_active


# On ready load state map, connect signals and start the first state
func _ready() -> void:
	# Load the states map, check if it is empty
	initialize_states_map()
	if !states_map.empty():
		# Connect the states' finished signal to change the scene 
		for child in get_children():
			child.connect("finished", self, "_change_state")
		# Start the first scene
		initialize(start_state)
	else:
		printerr("StateController.gd: States map empty. Please initalize it!")


# Use inheritage to define a mapping between state ids and their node paths
func initialize_states_map() -> void:
	pass


# Activates the FSM and starts with the specified state
func initialize(_start_state : NodePath) -> void:
	if _start_state:
		# Activates the FSM and enters first state
		set_active(true)
		states_stack.push_front(get_node(_start_state))
		current_state = states_stack[0]
		current_state.enter()
	else:
		printerr("StateController.gd: No start_state defined")


# De-/Activates the FSM
func set_active(_active : bool) -> void:
	active = _active
	set_physics_process(_active)
	set_process_input(_active)
	if !active:
		# Resets if not active
		states_stack = []
		current_state = null


# Update (only) the active state
func _physics_process(_delta : float) -> void:
	if active:
		current_state.update(_delta)


# Exectued uppon finishing an animation (only) the active state
func _on_animation_finished(anim_name = "") -> void:
	if active:
		current_state._on_animation_finished(anim_name)


# Changes the state to a new state or returns to the previous state
func _change_state(_state_name : String) -> void:
	if active:
		# Exits the current state
		current_state.exit()
		
#		print("StateController.gd: Changing state to ", _state_name)
		
		if _state_name == "previous":
			# Pop the last state to go to the previous
			if states_stack.size() > 1:
				states_stack.pop_front()
			else:
				printerr("StateController.gd: Cannot change to previous state! ",
				" State stack empty!")
		else:
			# Replace the old state (at index 0) with the new state on the stack
			states_stack[0] = states_map[_state_name]
		
		# Change the reference of current_state to the new one
		current_state = states_stack[0]
		emit_signal("state_changed", current_state)
		
		# Enter a new state
		if _state_name != "previous":
			current_state.enter()
