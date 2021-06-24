extends PlayerStateInAir
class_name PlayerStateJump

# Jump acceleration (defines jump height)
export (float) var jump_velocity = 480 # 360


# Function called uppon entering the state (not with previous)
func enter() -> void:
	.enter()
	# Accelerate only uppon entering
	var jump_force = owner.gravity_dir.rotated(PI) * jump_velocity
	
	owner.velocity += jump_force
	
	owner.play_directional_animation(state_animation)
	$JumpPlayer.play()


# Snap vector of the state 
func get_snap() -> Vector2:
	return Vector2()
