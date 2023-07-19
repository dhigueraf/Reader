extends Control

func setNombre(textonombre):
	$Nombre.text = textonombre + "..."
	
func setPagina(numpag):
	$Button.text = "Pagina " + str(numpag) 
