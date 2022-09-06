extends GridContainer

onready var children = get_children()

func show():
	# Refreshes the inventory screen with icons for each
	# item
	var item_list = Inventory.get_items()

	for index in item_list.size():
		children[index].texture_normal = item_list[index].icon_texture
