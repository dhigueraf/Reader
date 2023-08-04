extends Control

var pages = []
var actualindex = 0
var maxindex = 1
var interactivos = []
var tipointeraccion = "nada"
var parametrointera = ""
var lastdirection = 0

var thread

@export_node_path() var panelpath
var panel

@onready var dir = DirAccess.open( Global.basedir + "/converter")
# Called when the node enters the scene tree for the first time.
func _ready():

	var pagiterator = 0
	
	panel = get_node(panelpath)

	maxindex = Global.FileReading.numeropaginas -1
	$PageChanger/LabelNumPag.text = "/" + str(maxindex)
	
	$PageChanger/InputPaginas.max_value = maxindex

	print("current index " + str(Global.FileReading.currentindex) )
	
	print("File loaded")
	print(Global.FileReading)
	
	$Titulo.text = str(Global.FileReading.curso) + " -> " + str(Global.FileReading.nombre)
	
	if Global.FileReading.currentindex > 0:
		$PageChanger/avanzar.disabled = false
		$PageChanger/retroceder.disabled = false
	if Global.FileReading.currentindex >= Global.FileReading.numeropaginas-1:
		$PageChanger/avanzar.disabled = true
		$PageChanger/retroceder.disabled = false
	updateindex(Global.FileReading.currentindex)
	
	panel.deactivate()

func setimage(index):
	print("set iamge index: " + str(index))
	
	if dir.file_exists("pagina_" + str(index) + ".png"):
	
		var image = Image.load_from_file(Global.basedir + "/converter/" + "pagina_" + str(index) + ".png")
		var texture = ImageTexture.create_from_image(image)
		print(texture)
		
		$GraphEdit/GraphNode/TextureRect2.texture = texture
		
		thread = Thread.new()
		#var thread2 = Thread.new()
		
		print("Checkear proximo" )
		print( "pagina_" + str(index + 3) + ".png")
		
		if ( lastdirection == 1 ) and not ( dir.file_exists( "pagina_" + str(index + 3) + ".png" ) ) and ( (index + 3) < maxindex ):
			print("cargar por adelantado " + str(index + 3) )
			thread.start( _thread_LoadPages.bind(index + 3) )
			#Global.GenerarImagenes(Global.FileToRead.location,index + 3,false)
		else:
			print("existe siguiente" + "pagina_" + str(index + 3) + ".png")
		if ( lastdirection == -1 ) and not ( dir.file_exists( "pagina_" + str(index - 3) + ".png" ) ) and ( (index - 3) > 0 ):
			print("cargar por adelantado " + str(index - 3) )
			thread.start( _thread_LoadPages.bind(index - 3) )
	else:
		print("no existe la imagen")
		await Global.GenerarImagenes(Global.FileToRead.location,index,true)
		
		print("ahora cargarla")
		var image = Image.load_from_file(Global.basedir + "/converter/" + "pagina_" + str(index) + ".png")
		var texture = ImageTexture.create_from_image(image)
		print(texture)
		
		$GraphEdit/GraphNode/TextureRect2.texture = texture


func updateindex(num):
	actualindex = num
	Global.FileReading.currentindex = actualindex
	
	if actualindex == 0:
		$LabelPortada.visible = true
		$PageChanger/InputPaginas.set_value(0)
	else:
		$LabelPortada.visible = false
		$PageChanger/InputPaginas.set_value(actualindex)
		
	if actualindex == maxindex:
		$PageChanger/avanzar.disabled = true
	
	var showbutton = false
	var textoasignar = "interactivo"
	#Verificar si es interactivo
	
	setimage(actualindex)

func addtoindex(num):
	print("actualindex " + str(actualindex) )
	actualindex += num
	
	if num == 1:
		$PageChanger/retroceder.disabled = false
		if actualindex > maxindex -1:
			actualindex = maxindex
			$PageChanger/avanzar.disabled = true
		lastdirection = 1
	elif num == -1 or num == 0:
		$PageChanger/avanzar.disabled = false
		if actualindex < 1:
			actualindex = 0
			$PageChanger/retroceder.disabled = true
		lastdirection = -1
			
	#Global.FileReading.currentindex = actualindex	
	updateindex(actualindex)

#func disconectallnodes():
#	pass


func _on_avanzar_pressed():
	addtoindex(1)

func _on_retroceder_pressed():
	addtoindex(-1)

func _on_ButtonMapa_pressed():
	get_tree().change_scene_to_file("res://mapas/Mapas.tscn")

func _on_Button_pressed():
	pass # Replace with function body.


func _on_ButtonPlus_pressed():
	pass # Replace with function body.


func _on_GraphNode_dragged(from, to):
	print(from, to)


func _on_button_return_pressed():
	print("Volver inicio")
	get_tree().change_scene_to_file("res://Escenas/Curso.tscn")


func interactnode(nodedir):
	get_tree().change_scene_to_file(nodedir)
	
func interactexternal(filedir):
	OS.shell_open(filedir)


func _on_button_inteactivo_pressed():
	print("Interactivo")
	
	if tipointeraccion == "nodo":
		interactnode(parametrointera)
	elif tipointeraccion == "ppt":
		interactexternal(parametrointera)


func _on_button_ir_pagina_pressed():
	var pagvalue = $PageChanger/InputPaginas.get_value()
	if pagvalue > maxindex:
		pagvalue = maxindex
	elif pagvalue < 0:
		pagvalue = 0
	updateindex(pagvalue)
	
func _thread_LoadPages(number):
	print("I'm a thread! number is: ", str(number) )
	Global.GenerarImagenes(Global.FileToRead.location,number,false)
	
func _exit_tree():
	print("cerrar thread")
	thread.wait_to_finish()


func _on_print_button_pressed():
	print("Imprerosa")
	panel.activate("")
