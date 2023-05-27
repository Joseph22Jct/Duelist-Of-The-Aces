extends MeshInstance3D

class_name Card
# Called when the node enters the scene tree for the first time.
var type 
var num 
func SetCard(typetext, numbertext):
	$CardFaceUp.get_surface_override_material(0).set_shader_parameter("Texture", typetext)
	$CardFaceUp/CardFaceUpNumber.get_surface_override_material(0).set_shader_parameter("Texture", numbertext)
	pass
