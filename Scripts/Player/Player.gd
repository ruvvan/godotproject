class_name Player
extends Entity

# Preloads
var input = InputLogic.new()

# Declare array for input data
var input_data:Array

func _ready():
	# Signal Connections
	actions.connect("block_input", input, "disable_input")
	actions.timer.connect("timeout", input, "enable_input")

func _input(event):
	input_data = input.get_action_input(event)
	actions.input_action(input_data[0], input_data[1], self)

func _process(_delta):
	movement.move_axis = input.get_directional_input()

func _physics_process(_delta):
	movement.velocity = move_and_slide(movement.velocity)