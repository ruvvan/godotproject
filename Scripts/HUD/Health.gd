extends Control
# UI Health Bar
# TODO: Add functionality for depleting health when player is hit


var health_per_heart = 4
onready var max_health = Utilities.player.max_health
onready var heart_count = ceil(max_health / health_per_heart)
var current_health = max_health

# Positioning constants
const x_origin = 20
const x_offset = 18
const y_offset = 15

func _ready():
	# Initiate heart sprites
	for index in heart_count:
		add_heart(index)

func _process(_delta):
	# Monitor for Player's current health
	# TODO: Change this to only update when health changes
	current_health = Utilities.player.health

func create_heart(index):
	# Create heart sprite
	var heart = AnimatedSprite.new()
	var frames = load("res://Assets/HUD/HeartFrames.tres")
	heart.frames = frames

	# Set animation frame to show full heart
	heart.frame = 4

	# Set position
	heart.position = Vector2(x_origin + (index * x_offset), y_offset)

	return heart

func add_heart(index):
	# Add a child heart node
	var heart = create_heart(index)
	call_deferred("add_child", heart)
