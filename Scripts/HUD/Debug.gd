extends ItemList


func show():
	clear()
	for entity in get_tree().get_nodes_in_group("Entities (Debug)"):
		add_item(entity.name + ": " + entity.sprite.animation)