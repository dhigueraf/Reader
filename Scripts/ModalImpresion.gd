extends Control

var eldocu = preload("res://Objetos/BtnPagina.tscn")
var documento = {}
var option = 0
var pini = 0
var pfin = 0
var rangopags = ""
var notaspags = "0_0_0"
var nombrearchivo = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	
	$ColorRect/Label.text = "Imprimir doccumento "
	
	for cap in Global.FileToRead.capitulos:
		$ColorRect/CasoCaptiulo/CapOptions.add_item(cap.nombre)
	
	print(Global.FileReading)
	#print(Global.captituloactual)


func deleteoptions():
	print("delete options")
	var arrayeledocus = []
	arrayeledocus = $ColorRect/ScrollContainer/VBoxContainer.get_children()
	
	for eledocum in arrayeledocus:
		eledocum.queue_free()

func activate(document):
	print("activar panel")
	visible = true
	$ColorRect/CasoCaptiulo/CapOptions.select(Global.captituloactual.numero)
	$ColorRect/PrintOptions.select(0)
	slectprintoptions(0)
	$ColorRect/InputNombre.text = Global.FileToRead.nombre + "_notas"
	
func deactivate():
	visible = false

func _on_cross_button_pressed():
	deactivate()


func _on_print_options_item_selected(index):
	print("Seleccionado Index " + str(index))
	slectprintoptions(index)

func slectprintoptions(numero):
	option = numero
	match option:
		0:
			$ColorRect/CasoCaptiulo.visible = true
			$ColorRect/CasoCaptiulo/CapOptions.select(Global.captituloactual.numero)
			
			$ColorRect/CasoRango.visible = false
			
		1:
			$ColorRect/CasoCaptiulo.visible = false
			$ColorRect/CasoRango.visible = true
		2:
			$ColorRect/CasoCaptiulo.visible = false
			$ColorRect/CasoRango.visible = false

func generaterangearray(ini,fin):
	var iterator = ini
	while iterator <= fin:
		rangopags += str(iterator) + "_"
		iterator += 1
	rangopags = rangopags.left(-1)


func _on_btn_generar_pressed():
	print("Generar documento")
	#print(global)
	rangopags = ""
	notaspags = "0_0_0"
	var all = false
	
	match option:
		0:
			print("Capitulo")
			var selcap = $ColorRect/CasoCaptiulo/CapOptions.selected
			pini = Global.FileToRead.capitulos[selcap].paginainicio
			pfin = Global.FileToRead.capitulos[selcap].paginatermino
		1:
			print("Rango")
			pini = $ColorRect/CasoRango/inputDesde.value
			pfin = $ColorRect/CasoRango/inputHasta.value
		2:
			print("Completo")
			pini = 0
			pfin = Global.FileReading.numeropaginas -1
			all = true
	
	nombrearchivo = $ColorRect/InputNombre.text
	
	generaterangearray(pini,pfin)
	
	var arrynotasp = [0,0,0]
	arrynotasp[0] = $ColorRect/InputCuadriculada7.value
	arrynotasp[1] = $ColorRect/InputCuadriculada5.value
	arrynotasp[2] = $ColorRect/InputLineas.value
	notaspags = str(arrynotasp[0]) + "_" + str(arrynotasp[1]) + "_" + str(arrynotasp[2])
	
	print("paginas a imprimir")
	print(rangopags)
	print("arreglo de hojas")
	print(notaspags)

	Global.generatePDF(rangopags,notaspags,all,nombrearchivo,true)
	print("abrir archivos")
	print(Global.basedir  + "/generado/" +  nombrearchivo + ".pdf")
	OS.shell_open(Global.basedir  + "/generado/" +  nombrearchivo + ".pdf")


func _on_input_desde_value_changed(value):
	if value  > Global.FileReading.numeropaginas -1:
		$ColorRect/CasoRango/inputDesde.value = Global.FileReading.numeropaginas -1


func _on_input_hasta_value_changed(value):
	if value > Global.FileReading.numeropaginas -1:
		$ColorRect/CasoRango/inputHasta.value = Global.FileReading.numeropaginas -1
		
	if value < $ColorRect/CasoRango/inputDesde.value:
		$ColorRect/CasoRango/inputHasta.value = $ColorRect/CasoRango/inputDesde.value

