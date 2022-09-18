class_name Inventory
# Inventory logic
# Inventory capacity is based on stacks. Each item class has its own
# stack size.

signal inventory_full
signal update_equip

var max_capacity = 10
var item_list = {}
var equipment = {"Ranged": null, "Item": null}

func add_item(item, quantity=1):
	# Adds an item to the inventory list
	# Interactions that change inventory should check that this function returns
	# true before implementing additional permanent changes from the interaction,
	# in case inventory is full.
	# Returning true means the item was successfully added, false means failure

	if not can_add_stack():
		# If adding a new stack (item slot) isn't possible, check to see if the item
		# already exists in inventory, and if it has a partial stack to add to
		if item_list.has(item.item_name) and not item_list[item.item_name]["quantity"] % item_list[item.item_name]["stack_size"] == 0:
			item_list[item.item_name]["quantity"] += quantity
			return true
		else:
			emit_signal("inventory_full")
			return false
	else:
		if item_list.has(item.item_name):
			item_list[item.item_name]["quantity"] += quantity
		else:
			item_list[item.item_name] = {}
			item_list[item.item_name]["quantity"] = quantity
			item_list[item.item_name]["ref"] = item
			item_list[item.item_name]["stack_size"] = item.stack_size
	return true

func get_items():
	return item_list

func can_add_stack():
	# Checks to see if an additional stack (item slot) can be added
	if not item_list.keys():
		return true

	var total_stacks = 0
	for item in item_list.values():
		var stacks = ceil(float(item["quantity"])/item["stack_size"])
		total_stacks += stacks

	if total_stacks < max_capacity:
		return true
	else:
		return false

func remove_item(item, quantity=1):
	if item_list.has(item.item_name) and item_list[item.item_name]["quantity"] >= quantity:
		item_list[item.item_name]["quantity"] -= quantity

		if item_list[item.item_name]["quantity"] == 0:
			delete_item(item)

		return true
	else:
		return false

func delete_item(item):
	if item_list.has(item.item_name):
		item_list[item.item_name]["ref"].queue_free()
		item_list.erase(item.item_name)
		equipment_update()

func equip_item(item):
	if not item.equip_slot:
		return
		
	if equipment[item.equip_slot] == item:
		equipment[item.equip_slot] = null
	else:
		equipment[item.equip_slot] = item

	emit_signal("update_equip")

func equipment_update():
	for slot in equipment.keys():
		if not is_instance_valid(equipment[slot]):
			equipment[slot] = null
