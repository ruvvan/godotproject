class_name Item
extends StaticBody2D
# Item prototype

export(String) var item_name:String = "NoName"
export(bool) var key:bool = false
export(int) var potency:int = 0
export(String) var affects:String = "NoStat"

var signal_connect_dummy

var rng = RandomNumberGenerator.new()

var icon_path = "res://Assets/HUD/Shuriken.png"
var icon_texture = ImageTexture.new()

func _init():
	icon_texture = load(icon_path)

func _ready():
	rng.randomize()

	var rand_int = rng.randi_range(0,1)
	$Anim.play($Anim.get_animation_list()[rand_int])

	signal_connect_dummy = $GatherArea.connect("body_entered", self, "gather_item")

func use(_actor):
	print("using item!!")

func gather_item(body):
	if body == Utilities.player:
		if Inventory.add_item(duplicate()):
			queue_free()
