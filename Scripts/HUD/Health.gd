extends Control
# UI Health Bar

onready var hearts = $Hearts
onready var tween = $Tween

var health_per_heart = 4
onready var max_health = Utilities.player.max_health
onready var heart_count = ceil(max_health / health_per_heart)
onready var health = Utilities.player.health setget set_health
onready var current_health = 0 setget set_current_health

# Positioning constants
const x_origin = 20
const x_offset = 18
const y_offset = 15

func _ready():
	# Initiate heart sprites
	for index in heart_count:
		add_heart()

func _process(_delta):
	pass

func create_heart():
	# Create heart sprite
	var heart = AnimatedSprite.new()
	var frames = load("res://Assets/HUD/HeartFrames.tres")
	heart.frames = frames

	# Set animation frame to show full heart
	heart.frame = 4

	# Set position
	var index
	if len(hearts.get_children()):
		index = len(hearts.get_children())
	else:
		index = 0
	heart.position = Vector2(x_origin + (index * x_offset), y_offset)

	return heart

func add_heart():
	# Add a child heart node
	var heart = create_heart()
	hearts.add_child(heart)
	max_health = Utilities.player.max_health
	self.health = max_health

func remove_heart():
	# Remove a child heart node
	var index
	if len(hearts.get_children()):
		index = len(hearts.get_children()) - 1
	else:
		index = 0

	hearts.get_children()[index].queue_free()
	max_health = Utilities.player.max_health
	update_health()

func set_health(v):
	health = clamp(v, 0, max_health)
	tween.stop_all()
	tween.interpolate_property(self, "current_health", current_health, health, 0.1)
	tween.start()

func set_current_health(v):
	current_health = clamp(v, 0, max_health)
	var remaining_health = current_health
	for heart in hearts.get_children():
		heart.frame = 0
	for i in range(ceil(current_health / health_per_heart)):
		var child = hearts.get_child(i)
		var frame_target = clamp(remaining_health, 0, 4)
		remaining_health = clamp(remaining_health - 4, 0, INF)
		child.frame = frame_target

func update_health():
	self.health = Utilities.player.health
