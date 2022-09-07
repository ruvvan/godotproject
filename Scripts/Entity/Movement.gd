extends Node
class_name Movement

signal change_direction(dir)
signal change_velocity(vel)


# Direction / Speed / Velocity Setup
# Direction
var move_axis:Vector2 = Vector2() setget set_move_axis
# Speed
export(int) var base_speed = 50
export(int) var max_speed = 200
var speed = base_speed
# Velocity 
var velocity:Vector2 = Vector2() setget set_velocity
# Slide velocity
# As of 09/05/22, only used for knockbacks
var push_velocity:Vector2


# Public Methods
func scale_speed(pstate, scale):
	# Scale speed for "Sprint" action

	# For "Sprint" action, if key is pressed and speed
	# is below "max_speed", speed is scaled
	# Otherwise, speed is reset to "base_speed"
	if pstate and speed < max_speed:
		speed *= scale
	else:
		speed = base_speed


# Setters / Getters
func set_move_axis(v):
	# Sets entity direction vector

	# If direction is different from input direction,
	# emit direction change
	if move_axis != v:
		emit_signal("change_direction", v)

	move_axis = v

	# Assign velocity based on new direction
	# See "velocity" setter for more info
	self.velocity = move_axis.normalized() * speed

func set_velocity(v):
	# Sets entity velocity vector

	# If velocity is different from input velocity,
	# emit velocity change
	if velocity != v:
		emit_signal("change_velocity", v)
		
	velocity = v