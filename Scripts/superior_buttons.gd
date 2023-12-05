extends Control

func setLabelCurso(texto):
	$ButtonCurso/Curso.text = texto

func setTitulo(titulo):
	#$Flecha/Curso.text = texto
	$Titulo.text = titulo

func _on_button_curso_pressed():
	get_tree().change_scene_to_file("res://Escenas/Nivel.tscn")


func _on_button_gdd_pressed():
	get_tree().change_scene_to_file("res://Escenas/ListaGDD.tscn")


func _on_homebtn_pressed():
	get_tree().change_scene_to_file("res://Escenas/Home.tscn")
