class_name Chest
extends StaticBody2D

# Logic for openable containers

# Sprite
onready var sprite = $Sprite

# Openable detection area
onready var melee_area = $MeleeArea

# Openable detector and opened indicator
var openable:bool = false
var opened:bool = false

# Switch to determine contents
var trap:bool = false
var loot:Array
var rng = RandomNumberGenerator.new()

# Dummy variable to avoid warning for unused .connect() return value
var signal_connect_dummy

func _ready():
	# TODO: Modify this to possibly track persistent opened/closed state of container,
	# even across scene changes
	sprite.animation = "Closed"

	#Signal connections

	# Connect openable detection zone to openable switches
	signal_connect_dummy = melee_area.connect("body_entered", self, "_on_body_entered")
	signal_connect_dummy = melee_area.connect("body_exited", self, "_on_body_exited")

	# Set up item contents (if applicable)
	loot = Loot.items[0]
	rng.randomize()

func _on_body_entered(_body):
	# Make the chest openable
	openable = true

func _on_body_exited(_body):
	# Make the chest unopenable
	openable = false

func interaction(_actor):
	# Logic for opening the container
	if openable and not opened:
		sprite.animation = "Open"

		var rand_item = rng.randi_range(0, len(loot) - 1)
		var item_instance = loot[rand_item].instance()
		add_child(item_instance)

		# Make chest unopenable a second time
		# opened = true
		# openable = false
