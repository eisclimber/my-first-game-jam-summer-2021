extends KinematicBody2D
class_name DamageableKinematicBody

# Emitted once the body dies
signal die()
# Emitted once the player is (successfully) damaged, i.e. looses health
signal damaged(_amount)
# Emitted once the player is (successfully) damaged, i.e. gains health
signal healed(_amount)
# Emitted once the players' health changes
signal health_changed(from, to)

# Maximum HP of the player (full HP)
const MAX_HEALTH = 3

# Health of the body
export(int) var health = MAX_HEALTH
# Time of invincibility after beeing damaged
export(float) var damage_cooldown_seconds = 1

# Timer for damage cooldown
var damage_timer : Timer
# If the damage colldown timer is active
var invincible : bool = false


func _ready():
	health = min(health, MAX_HEALTH)
	# Setup and add damage timer node
	damage_timer = Timer.new()
	damage_timer.wait_time = damage_cooldown_seconds
	var _error = damage_timer.connect("timeout", self, "_on_DamageTimer_timeout")
	add_child(damage_timer)


# Damages the Body by _amount
func damage(_amount : int) -> void:
	# Only allow positive damage, use heal for healing
	if _amount > 0 and is_damageable():
		var new_health = clamp(health - _amount, 0, MAX_HEALTH)
		
		emit_signal("damaged", _amount)
		emit_signal("health_changed", health, new_health)
		
		health = new_health
		
		if is_alive():
			# Start invincible periode if still alive
			start_damage_timer()
		else:
			# Body is "dead"
			die()


# Heals the Body by _amount
func heal(_amount : int) -> void:
	# Only allow positive healing, use damage for damaging
	if _amount > 0:
		var new_health = clamp(health + _amount, 0, MAX_HEALTH)
		
		emit_signal("damaged", _amount)
		emit_signal("health_changed", health, new_health)
		
		health = new_health


# Returns whether or not the health is above 0
func is_alive() -> bool:
	return health > 0


# Returns wether or not damage can be inflicted
func is_damageable():
	return is_alive() and !invincible


# Executed once the bodys health reaches 0.
# Use queue_free() to remove/delete it
func die() -> void:
	emit_signal("die")


# Kills the body immediately
func kill() -> void:
	health = 0
	die()


# Starts the damage timer (i.e. invincibility periode) 
func start_damage_timer():
	invincible = true
	damage_timer.start()


# Ends invincibility periode (Body is damageable again)
func _on_DamageTimer_timeout() -> void:
	invincible = false
