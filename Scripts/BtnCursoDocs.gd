extends Node

var button = preload("res://Objetos/BtnCurso.tscn")


func changeTitle(titulo):
	$Label.text = titulo #$CanvasLayer/Control/Label.text = titulo
	
func addbutton(dictionary):
	
	var button = Button.new()
	button.text = str(dictionary.nombre.boton)
	#btndir.disabled = true
	
	print(dictionary)
	
	button.connect("pressed", Callable(self, "openDocumentPanel").bind(dictionary))
	$VBoxContainer.add_child(button) #$CanvasLayer/Control/VBoxContainer.add_child(button)
	
func openDocumentPanel(documento):
	print("abrir documento")
	print(documento)
	print( get_parent().get_parent() )
	get_parent().get_parent().activatePanel(documento)
	#activatePanel.emit()
