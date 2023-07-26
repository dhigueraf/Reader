extends GraphNode


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

@onready var text_edit = $TextEdit

# Called when the node enters the scene tree for the first time.
func _ready():
	text_edit.set_custom_minimum_size(Vector2(-1, get_rect().size.y-35))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_data():
	var frame_color = get("theme_override_styles/frame").get_border_color()
	var selected_frame_color = get("theme_override_styles/selected_frame").get_border_color()
	return {"text": text_edit.text, "title": get_title(), 
	"frame_color": {"r": frame_color.r, "g": frame_color.g, "b": frame_color.b}, 
	"selected_frame_color": {"r": selected_frame_color.r, "g": selected_frame_color.g, "b": selected_frame_color.b}}

func set_data(data):
	text_edit.text = data["text"]
	set_title(data["title"])	
	set_border_color(data["frame_color"], data["selected_frame_color"])	
	
	
func set_border_color_rgb(color_frame:Color, color_selected:Color):
	var style = get("theme_override_styles/frame").duplicate()
	style.set_border_color(color_frame)
	set("theme_override_styles/frame", style)
	var style_selected = get("theme_override_styles/selected_frame").duplicate()
	style_selected.set_border_color(color_selected)
	set("theme_override_styles/selected_frame", style_selected)
	
	
func set_border_color(color_frame:Dictionary, color_selected:Dictionary):
	var style = get("theme_override_styles/frame").duplicate()
	style.set_border_color(Color(color_frame["r"],color_frame["g"],color_frame["b"]))
	set("theme_override_styles/frame", style)
	var style_selected = get("theme_override_styles/selected_frame").duplicate()
	style_selected.set_border_color(Color(color_selected["r"],color_selected["g"],color_selected["b"]))
	set("theme_override_styles/selected_frame", style_selected)


func _on_close_request():
	get_parent().disconnect_connections_of_node(name)
	queue_free()
	#get_parent().save()


func _on_resize_request(new_size):
	var graph = get_parent()
	if graph.has_method("is_using_snap") and graph.is_using_snap():
		var snap = graph.get_snap()
		size.x = int(new_size.x/snap)*snap
		size.y = int(new_size.y/snap)*snap
	else:
		size = new_size
	text_edit.set_custom_minimum_size(Vector2(-1, size.y-35))
	#get_parent().save()


func _on_TextEdit_focus_entered():
	get_parent().set_selected(self)


func _on_TextEdit_text_changed():
	#get_parent().save()
	pass

func _on_GraphNode_gui_input(event):
	if event is InputEventMouseButton and event.double_click:
		#print(event)
		get_parent().change_title(self)
