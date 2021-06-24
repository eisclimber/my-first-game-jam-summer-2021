extends State
class_name PlayerState

# Acceleration of the player
export (float) var acceleration = 1600
# Max speed of the player in this state
export (float) var max_speed = 400
# Fiction (how fast the player slows down)
export (float, 0, 1) var friction = 0.4
# Name of the animation played during the state
export (String) var state_animation = "idle"


# Returns the input direction
# Each coordinate is either +-1 or 0. Not normalized!
func get_input_direction() -> Vector2:
	# Going left equals negative, right positive x
	var input_x = int(Input.is_action_pressed("move_right")) \
		 - int(Input.is_action_pressed("move_left"))
	
	# Use calculate x and y = 0 since there is no W/S movement
	return Vector2(input_x, 0)
