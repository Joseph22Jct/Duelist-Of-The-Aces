extends MeshInstance3D

class_name BoardTile

var TerrainType = 0
var BPos = []



var NormalTerrain = preload("res://Sprites/Tiles/Boards7.png")
var OddTerrain = preload("res://Sprites/Tiles/Boards1.png")
var EvenTerrain = preload("res://Sprites/Tiles/Boards2.png")
var DiamondTerrain = preload("res://Sprites/Tiles/Boards3.png")
var HeartTerrain = preload("res://Sprites/Tiles/Boards4.png")
var ClubTerrain = preload("res://Sprites/Tiles/Boards5.png")
var SpadeTerrain = preload("res://Sprites/Tiles/Boards6.png")
var OBG = preload("res://Sprites/Tiles/Boards8.png")
var EBG = preload("res://Sprites/Tiles/Boards9.png")
var DBG = preload("res://Sprites/Tiles/Boards10.png")
var HBG = preload("res://Sprites/Tiles/Boards11.png")
var CBG = preload("res://Sprites/Tiles/Boards12.png")
var SBG = preload("res://Sprites/Tiles/Boards13.png")

func SetType(Type):
	match Type:
		0:
			set_instance_shader_parameter("MainText", NormalTerrain)
		1:
			set_instance_shader_parameter("MainText", OddTerrain)
			set_instance_shader_parameter("BGText", OBG)
		2:
			set_instance_shader_parameter("MainText", EvenTerrain)
			set_instance_shader_parameter("BGText", EBG)
		3:
			set_instance_shader_parameter("MainText", DiamondTerrain)
			set_instance_shader_parameter("BGText", DBG)
		4:
			set_instance_shader_parameter("MainText", HeartTerrain)
			set_instance_shader_parameter("BGText", HBG)
		5:
			set_instance_shader_parameter("MainText", ClubTerrain)
			set_instance_shader_parameter("BGText", CBG)
		6:
			set_instance_shader_parameter("MainText", SpadeTerrain)
			set_instance_shader_parameter("BGText", SBG)
			pass
	TerrainType = Type
	print("Type Set to: " + str(Type)+ " at tile: "+ str(BPos))
			
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
