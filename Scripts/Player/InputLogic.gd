class_name InputLogic
extends Node
# Input logic for player characters


# Movement
var left:bool = false
var right:bool = false
var up:bool = false
var down:bool = false
var direction:Vector2 = Vector2()

# Actions
var block_input:bool = false

func get_action_input(event):
	# Check to see if an event is part of the input map
	var action:String = ""
	var pstate:bool = event.is_pressed()
	if not block_input:
		for _action in InputMap.get_actions():
			if event.is_action(_action):
				action = _action
	return [action, pstate]

# Movement
func get_directional_input():
	# Get directional input and coerce into direction vector

	if not block_input:
		left = Input.is_action_pressed("move_left")
		right = Input.is_action_pressed("move_right")
		up = Input.is_action_pressed("move_up")
		down = Input.is_action_pressed("move_down")

		direction = Vector2(-int(left)+int(right), -int(up)+int(down))
	else:
		direction = Vector2.ZERO
	return direction

func disable_input():
	block_input = true

func enable_input():
	block_input = false
