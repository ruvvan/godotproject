extends Node

# Player node for universal use
onready var player = get_tree().get_nodes_in_group("Player")[0]

func get_cardinal_direction(dir):
	# Get closest right angle from dir to x axis & match to a cardinal direction
	var dir_string
	var dir_vect
	var angle = floor((rad2deg(dir.angle())-45)/90)*90

	match angle:
		0.0:
			dir_string = "D"
			dir_vect = Vector2(0, 1)
		-180.0:
			dir_string = "U"
			dir_vect = Vector2(0, -1)
		90.0, -270.0:
			dir_string = "L"
			dir_vect = Vector2(-1, 0)
		-90.0:
			dir_string = "R"
			dir_vect = Vector2(1, 0)

	return [dir_string, dir_vect]
