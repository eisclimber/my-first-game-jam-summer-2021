extends PlayerState
class_name PlayerStateMovement

# Length of the snap vector
const SNAP_LENGTH = 32
# Animation to play when falling
const FALL_ANIMATION = "fall"
# Animation to play when jumping
const JUMP_ANIMATION = "jump"


# If true, the fall animation will be played if the player is falling
# overriding the state_animation
export(bool) var jump_animation_override = true
# If true, the fall animation will be played if the player is falling
# overriding the state_animation
export(bool) var fall_animation_override = true
# Threshold for the applied gravity to trigger the fall animation
# Does not change to the fall state
export (float) var jump_threshold = 1
# Threshold for the applied gravity to trigger the fall animation
# Does not change to the fall state
export (float) var fall_threshold = 300
# Push strength of the player
# (Applied only on objects that are in the group "pushable")
export (float) var push_strength = 100


# Updates the state (effectively calling _physics_process(_delta))
func update(_delta : float) -> void:
	apply_forces(_delta)
	owner.velocity = owner.move_and_slide_with_snap(owner.velocity, get_snap(), \
		Vector2.UP, true, 4, PI / 4, false)
	owner.play_directional_animation(get_animation_to_play())
	
	for i in owner.get_slide_count():
		var collision = owner.get_slide_collision(i)
		handle_collision(collision)
	
	make_state_changes()


# Changes states during the update funtion
func make_state_changes() -> void:
	# If Input is and Player is on floor, jump
	if Input.is_action_just_pressed("jump") and can_jump():
		emit_signal("finished", "jump")
	# If not moving goto idle
	elif owner.is_on_floor() and name != "Idle":
		emit_signal("finished", "idle")
	# If player starts to fall go to falling state
	elif !owner.is_on_floor() and (name == "Move" or name == "Idle"):
		emit_signal("finished", "fall")


# Applies velocity horizontal velocity (to gravity)
func apply_horizontal_velocity() -> void:
	# Get the user (horizontal) input
	var target_vel_x = get_input_direction().x * max_speed
	
	owner.velocity.x = lerp(owner.velocity.x, target_vel_x, friction)
	if !is_zero_approx(target_vel_x):
		owner.set_looking_right(target_vel_x < 0)


# Applies forces to the body
func apply_forces(_delta : float) -> void:
	# Applies gravity
	var gravity = Vector2.DOWN * owner.gravity_strength
	owner.velocity += (gravity * _delta)
	# Do not apply user input here!


# Function to receive and handle collisions of the Player
# Will automatically be called on all collisons occured during update
func handle_collision(_collision : KinematicCollision2D) -> void:
	# Handle Damage
	if _collision.collider.is_in_group("damage_inflictor"):
		var collision_pos = _collision.position - _collision.normal
		var damage = _collision.collider.get_damage_from_collision(\
			collision_pos, _collision)
		owner.damage(damage)
	
	# Handle pushing
	if _collision.collider.is_in_group("pushable"):
		var push_force = -_collision.normal * push_strength
		_collision.collider.apply_central_impulse(push_force)


# If the player is falling
func is_falling():
	return (owner.velocity.y >= fall_threshold)


# If the player is jumping
func is_jumping():
	return (owner.velocity.y <= -jump_threshold)


# If the player can jump
func can_jump() -> bool:
	return owner.is_on_floor()


# Snap vector of the state 
func get_snap() -> Vector2:
	return Vector2.DOWN * SNAP_LENGTH


func get_animation_to_play() -> String:
	if is_falling() and fall_animation_override:
		return FALL_ANIMATION
	elif is_jumping() and jump_animation_override:
		return JUMP_ANIMATION
	else:
		return state_animation
