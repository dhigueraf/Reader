extends PanelContainer
class_name InventorySlot


@export var type: InventoryItem.Type


# Custom init function so that it doesn't error
func init(t: InventoryItem.Type, cms: Vector2) -> void:
	type = t
	custom_minimum_size = cms


# _at_position is not used because it doesn't matter where on the panel
# the item is dropped
func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	print("candrop")
	if data is InventoryItem:
		if type == InventoryItem.Type.MAIN:
			if get_child_count() == 0:
				return true
			else:
				# Swap two items
				return get_child(0).type == data.type
		else:
			return data.type == type
	return false
