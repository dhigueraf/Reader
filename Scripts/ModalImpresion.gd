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
	visible = true
	
func deactivate():
	visible = false





func _on_cross_button_pressed():
	deactivate()
