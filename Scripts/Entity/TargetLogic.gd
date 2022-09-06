class_name TargetLogic
extends Node
# Logic for targeting other entities

# Declare list for ranged target list
var target_list:Array
# Initiate ranged and melee targets as null
var ranged_target = null
var melee_target = null
# Index for changing ranged target from "target_list"
var target_index:int = 0


# Signal reactions
func add_targetable_entity(entity):
	# Adds the entity to the target list when it enters the actor's
	# ranged area
	if not entity in target_list:
		target_list.append(entity)

func remove_targetable_entity(entity):
	# Removes the entity from the target list when it exits the
	# actor's ranged area
	if entity in target_list:
		target_list.erase(entity)

func change_target():
	# Cycle through entities in target list

	# If target list is empty, do nothing
	if not target_list.size():
		return

	# If next increment of target index is in array range,
	# increment target index. Otherwise, wrap index to 0
	if target_index < len(target_list) - 1:
		target_index += 1
	else:
		target_index = 0
	
	# Assign cycled target to be ranged target
	ranged_target = target_list[target_index]

func set_melee_target(body):
	# Sets the entity as the actor's melee target if it
	# enters the actor's melee range
	melee_target = body

func unset_melee_target(body):
	# Unsets the entity as the actor's melee target if
	# it exits the actor's melee range
	if body == melee_target:
		melee_target = null
