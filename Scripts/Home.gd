extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	
	print("Home JSON:")
	print(Global.JsonGDD)
	
	Global.SelectedCurso = {}
	Global.nivel = {}


func _on_button_pressed():
	
	get_tree().change_scene_to_file("res://Escenas/ListaGDD.tscn")


func _on_button_2_pressed():
	Global.selectedPestanaEditable="presentaciones"
	get_tree().change_scene_to_file("res://Escenas/Editables2.tscn")


func _on_button_3_pressed():
	Global.selectedPestanaEditable="evaluaciones"
	get_tree().change_scene_to_file("res://Escenas/Editables2.tscn")
