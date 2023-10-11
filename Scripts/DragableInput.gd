extends TextureRect
class_name InventoryItem


enum Type {HEAD, CHEST, LEGS, FEET, WEAPON, ACCESSORY, MAIN}

@export var type: Type


# Custom init function so that it doesn't error
func init(t: Type, i: Texture2D) -> void:
	type = t
	texture = i
	expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED


# _at_position is not used because it doesn't matter where we click on
# the inventory item.
func _get_drag_data(_at_position: Vector2) -> Variant:
	print("get drag data")
	set_drag_preview(make_drag_preview())
	return self


func make_drag_preview() -> TextureRect:
	print("make drag preview")
	var t := TextureRect.new()
	t.texture = texture
	t.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
	#t.custom_minimum_size = size
	return t
