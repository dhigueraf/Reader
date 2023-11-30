extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	var unidades = Global.JsonGDD.Unidad
	var colores = Global.JsonGDD.Color
	var listaunidades = []
	
	for tomo in Global.nivel.tomos:
		for unidad in tomo.unidades:
			var unitoadd = unidad
			unitoadd.nombre = unidades[ str(unidad.unidad_id) ].nombre
			unitoadd.color = colores[ str(unidades[ str(unidad.unidad_id) ].color_id) ]
			unitoadd.sigla = unidades[ str(unidad.unidad_id) ].sigla
			listaunidades.append(unidad)
	
	for unidad in listaunidades:
		print(unidad.nombre)


func _on_btn_presencaciones_pressed():
	$BtnEvaluaciones.button_pressed = false


func _on_btn_evaluaciones_pressed():
	$BtnPresencaciones.button_pressed = false

