extends MeshInstance3D

class_name Card
# Called when the node enters the scene tree for the first time.
var type 
var num = 0
var hideObj

func GetCard():
	var c = CardBase.new()
	c.type = type
	c.number = num
	return c
func SetCard(typetext, numbertext):
	hideObj= $CardFaceUp/CardFaceUpNumber/hideObj
	$CardFaceUp.get_surface_override_material(0).set_shader_parameter("Texture", typetext)
	$CardFaceUp/CardFaceUpNumber.get_surface_override_material(0).set_shader_parameter("Texture", numbertext)
	pass
