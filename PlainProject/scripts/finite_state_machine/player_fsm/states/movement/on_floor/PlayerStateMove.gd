extends PlayerStateMovement
class_name PlayerStateMove
#func update(_delta : float) -> void:
#	.update(_delta)
#	var input_direction = get_input_direction()
#	if input_direction != Vector2():
#		$SoundsPlayer.play()
	


# Applies forces to the body
func apply_forces(_delta : float) -> void:
	.apply_forces(_delta)
	# Apply user input
	apply_horizontal_velocity()

