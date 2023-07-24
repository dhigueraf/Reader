extends Control

var textonom = ""
var numpa = 0

func setNombre(textonombre):
	$Nombre.text = textonombre + "..."
	textonom = textonombre
	
func setPagina(numpag):
	numpa = numpag
	$Button.text = "Pagina " + str(numpag) 


func _on_button_pressed():
	print("abrir pagina: " + textonom + " [" + str(numpa)  + "]")
	print(Global.FileToRead)
	prepararanotas(Global.FileToRead.location,numpa)

func prepararanotas(location,pag):
	var converterdir = Global.basedir + "/converter"
	var filetoopen = Global.basedir + "/" + location
	print(converterdir)
	print("prepararNotas")
	var dir = DirAccess.open(converterdir)
	print("eliminar imagenes anteriores")
	if dir:
		dir.list_dir_begin()
		var iteratedname = dir.get_next()
		while (iteratedname != ""):
			if not dir.current_is_dir():
				print("Found file: " + iteratedname)
				var filearray = iteratedname.split(".")
				if( filearray[-1] == "png" ):
					print(iteratedname)
					dir.remove(converterdir + "/" + iteratedname)
			iteratedname = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	
	
	print("generar pdf images")
	print(filetoopen)
	var filetoopenarray = filetoopen.split(".")
	
	if filetoopenarray[-1] == "pdf":
		print("es convertible")
		var sistemaoperativo = OS.get_name()
		print(sistemaoperativo)
		var ejecutable = converterdir + "/pdf2pngimgs.exe"
		if sistemaoperativo.to_lower() == "windows":
			print("windows")
			ejecutable = converterdir + "/pdf2pngimgs.exe"
		elif sistemaoperativo.to_lower() == "x11" || sistemaoperativo.to_lower() == "linux":
			print("linux")
			ejecutable = converterdir + "/pdf2pngimg"
		
		var output = []
		OS.execute(ejecutable, [filetoopen], output, true)
		
		print("Ouput: ")
		for text in output:
			print(text)
		print("Fin Ejecución")

	print("Cambiar de escena")
	get_tree().change_scene_to_file("res://Escenas/Visualizador.tscn")
