extends PlayerStateInAir
class_name PlayerStateFall

# Periode for how long the player can jump even if already falling
export (float, 0, 1) var can_still_jump_for = 0.1

# Timer for the jump countdown
var jump_timer : Timer
# If the player can still jump
var can_still_jump : bool = true


# Add the jump timer and connect its timeout signal
func _ready() -> void:
	jump_timer = Timer.new()
	jump_timer.one_shot = true
	var _error = jump_timer.connect("timeout", self, "_on_JumpTimer_timeout")
	add_child(jump_timer)
	owner.play_directional_animation(state_animation)


# Let the player jump and start countdownd 
func enter() -> void:
	can_still_jump = true
	jump_timer.start(can_still_jump_for)


# Deny jumping once the timer has count down
func _on_JumpTimer_timeout() -> void:
	can_still_jump = false


# If the player can jump
func can_jump() -> bool:
	return can_still_jump
