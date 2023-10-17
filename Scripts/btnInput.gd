extends TextureButton

@export_enum("up", "down") var action = "down" 

@export_node_path() var pospath
@onready var currentpos = get_node(pospath)

@export_node_path() var pos2path
@onready var movepos = get_node(pos2path)



func _on_pressed():
	print(name + " pressed")
	
	print("previo")
	print("current")
	print( currentpos.get_child(0) )
	print("move")
	print( movepos.get_child(0) )
	var inputtomove = currentpos.get_child(0)
	var inputtomove2 = movepos.get_child(0)
	
	
	currentpos.remove_child(inputtomove)
	movepos.add_child(inputtomove)
	
	movepos.remove_child(inputtomove2)
	currentpos.add_child(inputtomove2)
	


	
	print("post")
	print("current")
	print( currentpos.get_child(0) )
	print("move")
	print( movepos.get_child(0) )



