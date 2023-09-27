extends Control

var eldocu = preload("res://Objetos/BtnPagina.tscn")
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
	$ColorRect/Label.text = document.nombre #document.nombre.boton
	
	documento = document
	
	deleteoptions()
	
	if "capitulos" in document:
		for capitulo in document.capitulos:
			var eldocum = eldocu.instantiate()
			eldocum.setNombre(capitulo.nombre)
			eldocum.setPagina(capitulo.paginainicio)
			$ColorRect/ScrollContainer/VBoxContainer.add_child(eldocum)
			Global.FileToRead = documento
	
	visible = true
	
func deactivate():
	visible = false


func _on_cross_button_pressed():
	deactivate()
	deleteoptions()
	documento = {}

func _on_btn_lector_pressed():
	print("abrir con lector externo")
	print(Global.basedir + "/" + documento.location)
	OS.shell_open(Global.basedir  + "/" +  documento.location)


func _on_btn_portada_pressed():
	await Global.DeletePreviousImages()
	await Global.GenerarImagenes(Global.FileToRead.location,0,true)
	print("Cambiar de escena")
	get_tree().change_scene_to_file("res://Escenas/Visualizador.tscn")


func _on_btn_pagina_pressed():
	var pagvalue = $ColorRect/paginput.get_value()
	await Global.DeletePreviousImages()
	print("pagvalue " + str(pagvalue))
	await Global.GenerarImagenes(Global.FileToRead.location,pagvalue,true)
	print("Cambiar de escena")
	get_tree().change_scene_to_file("res://Escenas/Visualizador.tscn")
