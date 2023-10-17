extends Control

@export var etiqueta = "Etiqueta del input"
@export var textvalue = "xmm"

var numvalue = 0

func _ready():
	$txt_cuadriculadas.text = etiqueta

func _on_input_cuadriculada_5_value_changed(value):
	numvalue = value

func getFinalValue():
	return textvalue + ":" + str(numvalue)
