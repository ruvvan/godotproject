extends ItemList

var selected_index = 0


func show():
	# Refreshes the inventory screen with icons for each item
	clear()
	var item_list = Inventory.get_items()

	for item in item_list.keys():
		add_item(item + ": " + str(item_list[item]["quantity"]), item_list[item]["ref"].icon_texture)
	
	selected_index = 0
	set_selection(selected_index)

func _input(event):
	if event.is_action_pressed("ui_right"):
		selected_index = clamp(selected_index + 1, 0, get_item_count() - 1)
		select(selected_index)
	if event.is_action_pressed("ui_left"):
		selected_index = clamp(selected_index - 1, 0, get_item_count() - 1)
		select(selected_index)

func set_selection(index):
	if get_item_count():
		select(index)
