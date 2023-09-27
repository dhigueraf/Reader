extends Button

var curso = {}

var managerbutton

func activateUButton(value):
	print("set update " + str(value) )
	$UpdateButton.disabled = value


func _on_update_button_pressed():
	print("Actualizar curso")
	print(curso)
	managerbutton.emit(curso)
	
	$UpdateButton.disabled = true
