extends Control



func _on_close_modal_btn_pressed():
	visible = false


func _on_update_btn_pressed():
	get_tree().change_scene_to_file("res://Escenas/FirstLoad.tscn")
