extends PlayerStateMove
class_name PlayerStateInAir


#func _ready() -> void:
#	friction = 0.05



# Updates the state (effectively calling _physics_process(_delta))
func update(_delta : float) -> void:
	.update(_delta)
	# Go to the gound movement if on the ground
	if owner.is_on_floor():
		emit_signal("finished", "move")


# Applies velocity horizontal velocity (to gravity)
func apply_horizontal_velocity() -> void:
	.apply_horizontal_velocity()
	if is_falling():
		owner.play_directional_animation(get_animation_to_play())


# If the player can jump
func can_jump() -> bool:
	# Can not jump while in air
	return false
