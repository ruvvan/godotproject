extends Camera2D


export(NodePath) var target_path = NodePath()
var target:Node

func _ready():
	target = get_node(target_path)

func _physics_process(_delta):
	position = target.position
