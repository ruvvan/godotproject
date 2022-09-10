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

func _on_body_entered(_body):
	# Make the chest openable
	openable = true

func _on_body_exited(_body):
	# Make the chest unopenable
	openable = false

func interaction(actor):
	# Logic for opening the container
	if openable and not opened:
		sprite.animation = "Open"

		# Arbitrary result for inventory testing
		# TODO: Change to refer to loot tables eventually
		var item = Item.new()
		Inventory.add_item(item)
		actor.remove_health()

		# Make chest unopenable a second time
		opened = true
		openable = false
