extends GraphEdit

export(NodePath) var popup
onready var graph_node = preload("res://mapas/GraphNode.tscn")
var basedir = ""
var copy = []


# Called when the node enters the scene tree for the first time.
func _ready():
	var path = OS.get_executable_path()
	basedir = path.get_base_dir() + "/mapas"
	load_save()
	#pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func save():
	var save_graph = File.new()
	save_graph.open(Global.FileToRead.location + "/" + Global.FileToRead.nombre  +".json", File.WRITE)
	var node_data = []
	for c in get_children():
		if c is GraphNode:
			node_data.append({"name": c.name, 
								"offset_x":c.get_offset().x, 
								"offset_y":c.get_offset().y,
								"size_x":c.get_rect().size.x,
								"size_y":c.get_rect().size.y,
								"data": c.get_data()})
	var data = {"connections": get_connection_list(), "nodes": node_data}
	Global.FileReading.paginas[Global.FileToRead.actualindex].mapaideas = data
	save_graph.store_line( to_json(Global.FileReading) )
	save_graph.close()
	print("saved!")

func load_save():
	var save_graph = File.new()
	if not save_graph.file_exists(Global.FileToRead.location + "/" + Global.FileToRead.nombre  +".json"):
		return # Error! We don't have a save to load.
		
	# clear graphedit
	for c in get_children(): 
		if c is GraphNode: 
			c.free()
	
	print(Global.FileToRead)
	#print(Global.FileToRead.actualindex)
	#print(Global.FileReading)
	#print(Global.FileReading.paginas)
	#print(Global.FileReading.paginas[Global.FileToRead.actualindex])
	var save_data = Global.FileReading.paginas[Global.FileToRead.currentindex].mapaideas
	#print(save_data)
	for node in save_data["nodes"]:
		var graph_node_instance = graph_node.instance()
		graph_node_instance.set_size(Vector2(float(node["size_x"]), float(node["size_y"])))
		add_child(graph_node_instance)
		graph_node_instance.name = node["name"]
		graph_node_instance.set_offset(Vector2(float(node["offset_x"]), float(node["offset_y"])))
		#print(graph_node_instance)
		graph_node_instance.set_data(node["data"])
	
	for conn in save_data["connections"]:
		connect_node(conn["from"], conn["from_port"], conn["to"], conn["to_port"])
	#save_graph.close()
	print("loaded!")

func get_connections(node_name):
	var ret = {"left": [], "right": []}
	for conn in get_connection_list():
		if node_name == conn["from"]: ret["right"].append(conn["to"])
		elif node_name == conn["to"]: ret["left"].append(conn["from"])
	return ret
	
	
func disconnect_connections_of_node(node_name):
	var conn = get_connections(node_name)
	for c in conn["left"]: disconnect_node(c, 0, node_name, 0)
	for c in conn["right"]: disconnect_node(node_name, 0, c, 0)
	#save()


func change_title(node):
	get_node(popup).activate(node)


func _on_GraphEdit_connection_request(from, from_slot, to, to_slot):
	connect_node(from, from_slot, to, to_slot)
	#save()


func _on_GraphEdit_connection_to_empty(from, from_slot, release_position):
	var new_node = graph_node.instance()
	new_node.set_offset(release_position-Vector2(0, new_node.rect_size.y/2))
	add_child(new_node)
	new_node.name = String(randi())
	connect_node(from, from_slot, new_node.name, 0)
	#save()


func _on_GraphEdit_connection_from_empty(to, to_slot, release_position):
	var new_node = graph_node.instance()
	new_node.set_offset(release_position-Vector2(new_node.rect_size.x, new_node.rect_size.y/2))
	add_child(new_node)
	new_node.name = String(randi())
	connect_node(new_node.name, 0, to, to_slot)
	#save()


func _on_GraphEdit_disconnection_request(from, from_slot, to, to_slot):
	disconnect_node(from, from_slot, to, to_slot)
	#save()


func _on_GraphEdit_delete_nodes_request():
	for c in get_children():
		if c is GraphNode and c.is_selected():
			disconnect_connections_of_node(c.name)
			c.queue_free()
	#save()


func _on_GraphEdit_copy_nodes_request():
	copy.clear()
	for c in get_children():
		if c is GraphNode and c.is_selected():
			copy.append(c)
	#save()


func _on_GraphEdit_paste_nodes_request():
	for c in copy:
		var new_c = c.duplicate()
		new_c.set_selected(false)
		new_c.set_offset(get_viewport().get_mouse_position()-Vector2(new_c.rect_size.x, 0)/2)
		add_child(new_c)
		new_c.name = String(randi())
	#save()


func _on_GraphEdit_duplicate_nodes_request():
	for c in get_children():
		if c is GraphNode and c.is_selected():
			var new_c = c.duplicate()
			new_c.set_selected(false)
			new_c.set_offset(get_viewport().get_mouse_position()-Vector2(new_c.rect_size.x, 0)/2)
			add_child(new_c)
			new_c.name = String(randi())
	#save()


func _on_GraphEdit__end_node_move():
	#save()
	pass


func _on_PlusButton_pressed():
	var graph_node_instance = graph_node.instance()
	graph_node_instance.set_size(Vector2(float(160), float(120) ))
	graph_node_instance.set_offset(Vector2(float(100), float(100)))
	add_child(graph_node_instance)


func _on_saveButton_pressed():
	save()


func _on_Button_pressed():
	print("volver al libro")
	print(Global.FileToRead.currentindex)
	get_tree().change_scene("res://Escenas/notas.tscn")
