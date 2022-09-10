class_name Actions
extends Node
# Entity actions
# Can be used by playable and non-playable entities

signal block_input
signal action_animation(act)
signal change_direction(dir)
signal create_projectile(dir)

# Cooldown timer
var timer


func _init():
	# Set up general cooldown timer
	timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = 0.2

func input_action(action, press_state, actor):
	# For player, matches input actions from input map to actions
	# For NPCs, this function has to be explicitly called with
	# the desired arguments

	# Ignore input if cooldown timer is active
	if timer.time_left:
		return

	# Match input action to possible abilities
	match action:
		"Kick":
			kick(actor)
		"Sprint":
			# TODO: Possibly change this to work in the movement object instead,
			# since it doesn't use a cooldown
			actor.movement.scale_speed(press_state, 4)
		"ChangeTarget":
			lock_on(actor)
		"Interact":
			var target = actor.target_logic.melee_target
			if target and target.has_method("interaction"):
				target.interaction(actor)
		"Throw":
			ranged_attack(actor)

	# Change animation according to input
	# Some actions will not have an animation change,
	# but that is handled in the Sprite node when
	# the animation change is resolved.
	emit_signal("action_animation", action)
	
func face_entity(actor, target):
	# Face an actor toward a target

	# Set up direction vector between actor and target
	var direction = (target.position - actor.position).normalized()

	# Emit direction change to Sprite
	emit_signal("change_direction", direction)

	# Emit direction change to 0 to stop movement
	emit_signal("change_direction", Vector2.ZERO)

	# Return direction vector for use in trajectory calculations
	return direction

func kick(actor):
	# Kick attack
	# TODO: Change this to be a general melee attack, with or without a weapon

	# Emit input block to prevent input over consecutive frames
	emit_signal("block_input")

	# Emit direction change to stop movement
	emit_signal("change_direction", Vector2.ZERO)

	# Start cooldown timer
	timer.start()

	# Get the entity (if any) within the melee range of the actor
	var target = actor.target_logic.melee_target

	# Check if target entity exists and it can be attacked
	if target and target.has_method("hit"):
		# Health and pushback changes
		# TODO: Change this to vary depending on attack strength
		target.hit()

func lock_on(actor):
	# Change ranged target

	# Emit input block to prevent input over consecutive frames
	emit_signal("block_input")

	# Start cooldown timer
	timer.start()

	# Defer target change to actor's target logic instance
	actor.target_logic.change_target()

	# Get the entity that the actor is now targeting
	# Should default to the actor itself if no other actors in range
	var target = actor.target_logic.ranged_target

	# Check if actor's ranged target exists and faces it if so
	if target:
		face_entity(actor, target)

func ranged_attack(actor):
	# Ranged attack

	# Emit input block to prevent input over consecutive frames
	emit_signal("block_input")

	# Emit direction change to stop movement
	emit_signal("change_direction", Vector2.ZERO)

	# Start cooldown timer
	timer.start()

	# Initiate attack direction and get actor's ranged target
	var direction = Vector2()
	var target = actor.target_logic.ranged_target

	# If actor's ranged target exists, actor faces it
	if target:
		direction = face_entity(actor, target)

	# If the actor is not targeting itself, a projectile is created
	# in that direction
	# (target_logic.change_target() defaults to the actor itself)
	if not target == actor:
		emit_signal("create_projectile", direction)
