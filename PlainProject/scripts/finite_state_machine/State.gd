extends Node
class_name State

# Emitted to change the state. Use a state id or "previous"
signal finished(_next_state)


# Randomizes seed for random behavior
func _ready():
	randomize()


# Function called uppon entering the state (not with previous)
func enter():
	pass


# Function called uppon entering the state (not with previous)
func exit():
	pass


# Updates the state (effectively calling _physics_process(_delta))
func update(_delta):
	pass


# Can be used change bahaviour dependent on a finished animation
# Notice: Must be connected to an AnimationPlayers signal first
func _on_animation_finished(_anim_name):
	pass
