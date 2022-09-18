extends Node

onready var health = $HUD/HUD/Health
onready var equipmentgrid = $HUD/HUD/Menu/Inventory/Equipment/EquipmentGrid


func _ready():
	Utilities.player.connect("hit", health, "update_health")
	Utilities.player.connect("add_health", health, "add_heart")
	Utilities.player.connect("remove_health", health, "remove_heart")
	Utilities.player.inventory.connect("update_equip", equipmentgrid, "show")