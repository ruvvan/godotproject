extends Node

# Max capacity matches the total number of child button nodes under inventory node
var max_capacity = 36
var item_list = []

func add_item(item):
    # Adds an item to the inventory list
    # Interactions that change inventory should yield to this function before implementing
    # Permanent changes from interaction, in case inventory is full.

    # Check if inventory is full
    if len(item_list) >= max_capacity:
        print("Inventory Full")
        return

    item_list.push_back(item)

func get_items():
    return item_list