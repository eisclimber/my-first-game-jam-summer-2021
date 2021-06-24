extends PlayerStateMovement
class_name PlayerStateIdle

# Play idle animation
func enter() -> void:
	.enter()
	owner.play_directional_animation("idle")


# Function called uppon entering the state (not with previous)
func update(_delta : float) -> void:
	.update(_delta)
	# Go to movement state if moving
	if get_input_direction() != Vector2():
		emit_signal("finished", "move")
