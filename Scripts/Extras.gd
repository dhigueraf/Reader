extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Button_pressed():
	get_tree().change_scene_to_file("res://snake/SnakeMainScene.tscn")


func _on_Button2_pressed():
	get_tree().change_scene_to_file("res://mapas/Mapas.tscn")
