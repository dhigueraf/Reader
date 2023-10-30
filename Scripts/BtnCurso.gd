extends Button

var curso = {}

var managerbutton

func activateUButton(value):
	print("set update " + str(value) )
	$UpdateButton.disabled = value


func setVersion(value):
	print("Set version" + str(value))
	$VersionLabel.text = "version: 1." + str(value)
	
func acivardetalles():
	$DetallerBtn.visible = true

func _on_update_button_pressed():
	print("Actualizar curso")
	print(curso)
	managerbutton.emit(curso)
	
	$UpdateButton.disabled = true
