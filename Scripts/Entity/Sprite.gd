extends AnimatedSprite

# Sprite Animations
# Generally named in spriteframes as strings of the form 'anim_type + anim_direction'
# When naming patterns differ, "animation" property is assigned directly
var anim_type:String = "Idle" setget set_anim_type
var anim_direction:String = "D" setget set_anim_direction
var anim_string:String = anim_type + anim_direction

# Encapsulates parent node for quick reference
onready var owner_entity = self.owner


# Signaled reactions
# Direction changes
func _on_direction_changed(dir):
	# Changes "anim_direction" if direction change is signaled

	# Check for non-zero direction vector
	# Return if vector is zero
	if not dir.length():
		return

	# Get nearest cardinal direction (north, south, east, or west)
	var direction = Utilities.get_cardinal_direction(dir)

	# Assign direction based on string representation of nearest
	# cardinal direction
	# See "anim_direction" setter for more info
	self.anim_direction = direction[0]

	# Changes melee target detection area to be in front of entity
	# TODO: Change to be more strict by checking if owner node
	# has a melee target detection area, or move this to the
	# entity node.
	owner_entity.melee_area.position = direction[1] * 9

# Velocity
func _on_velocity_changed(vel):
	# Changes "anim_type" if velocity change is signaled

	# Check for zero or non-zero velocity, and assign "anim_type" accordingly.
	# See "anim_type" setter for more info
	if vel.length() > 0:
		self.anim_type = "Walk"
	else:
		self.anim_type = "Idle"

# Actions
func _on_action(action):
	# Changes "anim_type" if action is signaled
	# See "anim_type" setter for more info
	self.anim_type = action

# Reset
func reset_anim():
	# Resets "anim_type" to idle
	self.anim_type = "Idle"

# Private Methods
func _update_anim():
	# Update animation

	anim_string = anim_type + anim_direction

	# Set animation to "anim_string" if it exists in the sprite's frames library
	if anim_string in self.frames.get_animation_names():
		animation = anim_string


# Setters / Getters
func set_anim_direction(v):
	# Changes direction if different from current direction
	if anim_direction != v:
		anim_direction = v
		_update_anim()

func set_anim_type(v):
	# Changes animation type if different from current animation type
	if anim_type != v:
		anim_type = v
		_update_anim()
