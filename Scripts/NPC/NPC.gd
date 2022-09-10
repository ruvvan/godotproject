class_name NPC
extends Entity

# Encapsulate player node for quick reference
onready var player = Utilities.player


func _ready():
	# Signal connections
	# Connect action limit switch to enable/disable input methods
	actions.connect("block_input", self, "block_input")
	actions.timer.connect("timeout", self, "enable_input")

func _process(_delta):
	if not $Timer.time_left:
		actions.input_action("Kick", true, self)
		$Timer.start()

func enable_input():
	# Input off switch
	disabled = false

func block_input():
	# Input on switch
	disabled = true
