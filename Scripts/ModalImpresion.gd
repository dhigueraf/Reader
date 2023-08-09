extends Control

var eldocu = preload("res://Objetos/BtnPagina.tscn")
var documento = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	
	$ColorRect/Label.text = "Imprimir doccumento "
	
	#$ColorRect/PrintOptions.add_item("Capitulo actual",0)
	#$ColorRect/PrintOptions.add_item("Rango de paginas",1)
	#$ColorRect/PrintOptions.add_item("Completo",2)
	
	for cap in Global.FileToRead.capitulos:
		$ColorRect/CasoCaptiulo/CapOptions.add_item(cap.nombre)
	
	
	print(Global.FileReading)
	#print(Global.captituloactual)
	
func deleteoptions():
	print("delete options")
	var arrayeledocus = []
	arrayeledocus = $ColorRect/ScrollContainer/VBoxContainer.get_children()
	
	for eledocum in arrayeledocus:
		eledocum.queue_free()

func activate(document):
	print("activar panel")
	visible = true
	$ColorRect/CasoCaptiulo/CapOptions.select(Global.captituloactual.numero)
	$ColorRect/PrintOptions.select(0)
	slectprintoptions(0)
	
func deactivate():
	visible = false

func _on_cross_button_pressed():
	deactivate()


func _on_print_options_item_selected(index):
	print("Seleccionado Index " + str(index))
	slectprintoptions(index)

func slectprintoptions(numero):
	match numero:
		0:
			$ColorRect/CasoCaptiulo.visible = true
			$ColorRect/CasoCaptiulo/CapOptions.select(Global.captituloactual.numero)
			
			$ColorRect/CasoRango.visible = false
			
		1:
			$ColorRect/CasoCaptiulo.visible = false
			$ColorRect/CasoRango.visible = true
		2:
			$ColorRect/CasoCaptiulo.visible = false
			$ColorRect/CasoRango.visible = false
