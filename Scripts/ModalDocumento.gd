extends Control

var eldocu = preload("res://Objetos/OptionsCurso.tscn")
var documento = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

func deleteoptions():
	print("delete options")
	var arrayeledocus = []
	arrayeledocus = $ColorRect/ScrollContainer/VBoxContainer.get_children()
	
	for eledocum in arrayeledocus:
		eledocum.queue_free()

func activate(document):
	print("activar panel")
	print(document)
	$ColorRect/Label.text = document.nombre.boton
	
	documento = document
	
	deleteoptions()
	
	for capitulo in document.capitulos:
		var eldocum = eldocu.instantiate()
		eldocum.setNombre(capitulo.nombre)
		eldocum.setPagina(capitulo.paginainicio)
		$ColorRect/ScrollContainer/VBoxContainer.add_child(eldocum) 
	
	visible = true
	
func deactivate():
	visible = false


func _on_cross_button_pressed():
	deactivate()
	deleteoptions()
	documento = {}

func _on_btn_lector_pressed():
	print("abrir con lector externo")
	print(documento)
