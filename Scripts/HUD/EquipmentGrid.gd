extends GridContainer

var equipment
var default_texture = load("res://Assets/HUD/EmptyTile.png")

func show():
	Utilities.player.inventory.equipment_update()
	equipment = Utilities.player.inventory.equipment

	for slot in equipment.keys():
		change_texture(slot)

		if equipment[slot]:
			change_texture(slot, equipment[slot].icon_texture)

func change_texture(slot, texture=default_texture):
	var image = texture.get_data()
	image.resize(32, 32, 0.25)
	var slot_node = get_node(slot)
	slot_node.texture = ImageTexture.new()
	slot_node.texture.create_from_image(image)
