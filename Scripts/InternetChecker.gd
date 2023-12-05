extends Control

@export var askModal = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func setInternetIcon(value):
	
	if value:
		$InternetNo.visible = false
		$InternetSi.visible = true
	else:
		$InternetNo.visible = true
		$InternetSi.visible = false
	
