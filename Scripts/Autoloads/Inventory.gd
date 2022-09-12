extends Node


# Max capacity matches the total number of child button nodes under inventory node
var max_capacity = 10
var item_list = {}

func add_item(item):
	# Adds an item to the inventory list
	# Interactions that change inventory should yield to this function before implementing
	# Permanent changes from interaction, in case inventory is full.

	# Check if inventory is full
	if len(item_list) >= max_capacity:
		print("Inventory Full")
		return false

	if item_list.has(item.item_name):
		item_list[item.item_name]["quantity"] += 1
	else:
		item_list[item.item_name] = {}
		item_list[item.item_name]["quantity"] = 1
		item_list[item.item_name]["ref"] = item

	return true

func get_items():
	return item_list
