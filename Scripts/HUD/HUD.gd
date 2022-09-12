extends Control
# HUD Logic


# Encapsulate Menu node for quick reference
onready var menu = $Menu

func _ready():
	pass

func _input(event):
		# Open or close menu
		if event.is_action_pressed("Menu"):
			toggle_pause()

		# Change tabs in menu
		if event.is_action_pressed("ChangeTarget") and $Menu.visible:
			if menu.current_tab < menu.get_tab_count() - 1:
				menu.current_tab += 1
			else:
				menu.current_tab = 0

		# Select an item
		if event.is_action_pressed("Interact") and $Menu.visible:
			if $Menu.get_current_tab_control().name == "Inventory":
				var selected_item = $Menu/Inventory.get_item_text($Menu/Inventory.selected_index).split(": ")[0]
				Inventory.item_list[selected_item]["ref"].use(Utilities.player)

func toggle_pause():
	if get_tree().paused:
		get_tree().paused = false
		menu.visible = false
	else:
		get_tree().paused = true
		menu.visible = true
		$Menu/Inventory.show()
		$Menu/Debug.show()
