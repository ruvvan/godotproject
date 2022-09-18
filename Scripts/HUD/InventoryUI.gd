extends ItemList

var selected_index = 0
var item_list
var equipment

func show():
	# Refreshes the inventory screen with icons for each item
	clear()
	item_list = Utilities.player.inventory.get_items()
	equipment = Utilities.player.inventory.equipment

	for item in item_list.keys():
		# For representation of stacks, add an item for every stack_size number of items
		# and one item for a partial stack
		var stacks = item_list[item]["quantity"] / item_list[item]["stack_size"]
		var partial_stack = item_list[item]["quantity"] % item_list[item]["stack_size"]

		for _stack in range(0, stacks):
			add_item(item + ": " + str(item_list[item]["stack_size"]), item_list[item]["ref"].icon_texture)
		if not partial_stack == 0:
			add_item(item + ": " + str(partial_stack), item_list[item]["ref"].icon_texture)
	
	selected_index = 0
	set_selection(selected_index)

func _input(event):
	if self.owner.menu.visible and self.owner.menu.current_tab == 1 and get_item_count():
		if event.is_action_pressed("ui_right"):
			selected_index = clamp(selected_index + 1, 0, get_item_count() - 1)
			select(selected_index)
		if event.is_action_pressed("ui_left"):
			selected_index = clamp(selected_index - 1, 0, get_item_count() - 1)
			select(selected_index)
		if event.is_action_pressed("Interact"):
				equip(selected_index)

func set_selection(index):
	if get_item_count():
		select(index)

func get_selection(index):
	var item_name = get_item_text(index).get_slice(": ", 0)
	return item_name

func equip(index):
	var item_name = get_selection(index)
	var item = item_list[item_name]["ref"]
	Utilities.player.inventory.equip_item(item)
