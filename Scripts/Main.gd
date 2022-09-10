extends Node

onready var health = $HUD/HUD/Health


func _ready():
	Utilities.player.connect("hit", health, "_on_player_hit")
	Utilities.player.connect("add_health", health, "add_heart")
	Utilities.player.connect("remove_health", health, "remove_heart")