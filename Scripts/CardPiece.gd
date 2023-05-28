extends Node3D

class_name CardPiece

var P1Border = preload("res://Sprites/Cards/Borders1.png")
var P2Border = preload("res://Sprites/Cards/Borders2.png")


var rotOffset

var type = 0
var number = 0
var flipped = false
var BPos = 0
var POwner = 0
var CardObj :Node3D
var waited = false
# Called when the node enters the scene tree for the first time.
func SetUp(typ, val, own, pos):
	type = typ
	number = val
	POwner = own
	BPos = pos
	if(POwner == 1):
		rotOffset = Vector3(0,0,0)
		$Border.get_surface_override_material(0).set_shader_parameter("Texture", P1Border)
	else:
		rotOffset = Vector3(0,180,0)
		$Border.get_surface_override_material(0).set_shader_parameter("Texture", P2Border)
	if type == 0:
		get_node("Leader").visible = true
	
	PlacePiece(BPos)

func ToggleWait(boolean):
	$Wait.visible = boolean
	waited = boolean

func flipCard():
	if type == 0:
		return
	else:
		var tween =  get_tree().create_tween()
		tween.tween_property(CardObj, "rotation_degrees", Vector3(CardObj.rotation_degrees.x,CardObj.rotation_degrees.y,180*int(flipped)),0.2)
		
		
	pass
func PlacePiece(curPos): ##Maybe on placing first time the card falls from the sky?
	print(curPos)
	var nPos = Vector3(2*(curPos[0]-3),position.y,2*(curPos[1]-3))
	print(nPos)
	position = nPos
	rotation_degrees = rotOffset
