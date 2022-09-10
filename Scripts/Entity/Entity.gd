class_name Entity
extends KinematicBody2D

signal hit(damage)

# General entity
# Base class for NPCs and Player characters

# Imports
# Variables and functions for movement logic
var movement = Movement.new()
# Variables and functions for actions logic
var actions = Actions.new()
# Variables and functions for targeting logic
var target_logic = TargetLogic.new()

# Dummy variable to avoid warning for unused .connect() return value
var signal_connect_dummy

# Collisions
var collision

# Disable switch
var disabled:bool = false setget set_disabled

# Targeting
# Initial ranged target path
export(NodePath) var target_path
# Encapsulation of target detection zones for quick reference 
onready var melee_area = $MeleeArea
onready var ranged_area = $RangedArea
# Preload projectile scene for quick instancing
var projectile = preload("res://Scenes/Actors/Projectile.tscn")
# Switch to determine whether entity can participate in combat
# TODO: Currently this is used as a kind of invincibility switch
# to prevent characters from receiving/giving damage. Possibly change
# to be two switches for impotence (inability to deal damage) and
# invincibility (inability to take damage)
export(bool) var combat:bool = false

# Sprite
# Encapsulation of sprite node for quick reference
onready var sprite = $Sprite

# Stats
# Encapsulation of health bar node for quick reference
onready var health_bar = $HealthBar
# Set maximum health
export(int) var max_health = 20
# Initiate health variable with setter only
onready var health setget set_health


# Private Methods
func _ready():
	# Add the action cooldown timer to the scene tree
	self.add_child(actions.timer)

	# Set ranged target to self if target_path is not set
	if target_path == "":
		target_path = self.get_path()
	target_logic.ranged_target = get_node(target_path)

	# Set up Health Bar
	health_bar.max_value = max_health
	health_bar.value = max_health
	health = max_health

	# Removes combat function and sprite decorations for non-combat-enabled
	# entities
	# TODO: See "var combat" declaration
	if not combat:
		health_bar.visible = false

	# Signal Connections
	# Connect movement changes to sprite animation changes
	signal_connect_dummy = movement.connect("change_direction", sprite, "_on_direction_changed")
	signal_connect_dummy = movement.connect("change_velocity", sprite, "_on_velocity_changed")

	# Connect ranged target detection area to targeting logic
	signal_connect_dummy = ranged_area.connect("body_entered", target_logic, "add_targetable_entity")
	signal_connect_dummy = ranged_area.connect("body_exited", target_logic, "remove_targetable_entity")

	# Connect melee target detection area to targeting logic
	signal_connect_dummy = melee_area.connect("body_entered", target_logic, "set_melee_target")
	signal_connect_dummy = melee_area.connect("body_exited", target_logic, "unset_melee_target")

	# Connect actions to sprite animation changes
	actions.connect("action_animation", sprite, "_on_action")
	# Connect actions to direction changes
	actions.connect("change_direction", movement, "set_move_axis")
	# Connect action cooldown timer timeout to sprite animation changes
	actions.timer.connect("timeout", sprite, "reset_anim")
	# Connect ranged attack action to projectile node creation
	actions.connect("create_projectile", self, "create_projectile")

func _physics_process(_delta):
	# Physics logic for entity

	# Predetermined physics logic for moving an entity along a vector
	# and recording collisions. Godot built-in for PhysicsBody2D
	collision = move_and_collide(movement.move_axis)

	# Predetermined physics logic for momentum interaction between physics entities
	# Godot built-in for PhysicsBody2D
	# As of 09/05/22, this is only used for knockback from the "Kick" action
	movement.push_velocity = move_and_slide(movement.push_velocity)
	# Linearly dampens push velocity so pushed entities don't slide indefinitely
	movement.push_velocity = movement.push_velocity.linear_interpolate(Vector2.ZERO, 0.1)


# Public Methods
func interaction(_actor):
	# Reaction upon interaction call by another entity
	# As of 09/05/22, this is a placeholder, to be overridden by
	# inherited nodes.
	# TODO: For entities, change this to be handled by an Area2D child node,
	# mostly for dialog purposes
	pass

func death():
	# Called when the entity's health reaches 0

	# Sprite animation change
	sprite.animation = "Dead"

	# Disables all functionality for entity
	# See "disabled" setter for more info
	self.disabled = true

	# Hides health bar for immersion
	health_bar.visible = false

func create_projectile(dir):
	# Creates projectile child nodes when ranged attack is initiated

	# Create an instance of "Projectile" scene
	var projectile_scene = projectile.instance()

	# Add instance to scene tree
	self.owner.add_child(projectile_scene)

	# Correct position of projectile so it doesn't instantaneously collide
	# with the thrower. Calculated from thrower's global position, offset
	# by scaled unit vector in direction of projectile's trajectory
	projectile_scene.global_position = global_position + (dir.normalized() * 15)

	# Set projectile's trajectory
	projectile_scene.direction = dir

func hit(damage=1):
	self.health -= damage
	emit_signal("hit", damage)
	print(health)


# Setters / Getters
func set_disabled(v):
	# Disabled switch setter

	disabled = v

	# Set processes to run if disabled is false, or to stop if disabled is true
	set_process_input(!v)
	set_process(!v)

func set_health(v):
	# Sets entity's health

	# Do nothing if node is not loaded into scene tree or the entity is not
	# combat-enabled.
	# TODO: See "var combat" declaration
	if not is_inside_tree() or not combat:
		return

	health = clamp(v, 0, max_health)

	# Set health bar value
	health_bar.value = health

	# Check if entity is dead
	if not health_bar.value:
		death()