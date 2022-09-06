class_name Item
# Item prototype

var item_name = "NoName"
var key:bool = false
var potency = 0
var affects = "NoStat"

var icon_path = "res://Assets/HUD/ShurikenButton.png"
var icon_texture = ImageTexture.new()

func _init():
	icon_texture = load(icon_path)
