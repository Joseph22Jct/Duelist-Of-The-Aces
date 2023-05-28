extends MeshInstance3D

class_name BoardTile

var TerrainType = 0
var BPos = []
var Actionable = false
var Summon = false ##Can move or summon
var Movement = false
var Piece = null

var highlightTile = preload("res://Sprites/highlight cursor.png")
var summonTile = preload("res://Sprites/summonTile.png")
var movTile = preload("res://Sprites/movementTile.png")

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
	Globals.Cursor.connect("CursorMoved", Callable(self, "CheckHighlight"))
	match Type:
		0:
			get_surface_override_material(0).set_shader_parameter("MainText", NormalTerrain)
		1:
			get_surface_override_material(0).set_shader_parameter("MainText", OddTerrain)
			get_surface_override_material(0).set_shader_parameter("BGText", OBG)
			
		2:
			get_surface_override_material(0).set_shader_parameter("MainText", EvenTerrain)
			get_surface_override_material(0).set_shader_parameter("BGText", EBG)
		3:
			get_surface_override_material(0).set_shader_parameter("MainText", DiamondTerrain)
			get_surface_override_material(0).set_shader_parameter("BGText", DBG)
		4:
			get_surface_override_material(0).set_shader_parameter("MainText", HeartTerrain)
			get_surface_override_material(0).set_shader_parameter("BGText", HBG)
		5:
			get_surface_override_material(0).set_shader_parameter("MainText", ClubTerrain)
			get_surface_override_material(0).set_shader_parameter("BGText", CBG)
		6:
			get_surface_override_material(0).set_shader_parameter("MainText", SpadeTerrain)
			get_surface_override_material(0).set_shader_parameter("BGText", SBG)
			pass
	TerrainType = Type
	print("Type Set to: " + str(Type)+ " at tile: "+ str(BPos))
			
# Called when the node enters the scene tree for the first time.
func CheckHighlight(oldpos = null, curpos= null):
	if(oldpos == null):
		oldpos = Globals.Cursor.oldPos
		pass
	
	if(curpos == null):
		curpos = Globals.Cursor.curPos
		pass
		
	if(Summon):
		$"Highlight-offcursor".visible = false
		$Highight.visible = false
		if(Actionable):
			$"Highlight-offcursor".visible = true
			$"Highlight-offcursor".get_surface_override_material(0).set_shader_parameter("Text", summonTile)
		
		if(curpos[0] == BPos[0] and curpos[1]== BPos[1]):
			$Highight.visible = true
			
		return

		
	$Highight.visible = false
	$"Highlight-offcursor".visible = false
	if(curpos[0] == BPos[0] or curpos[1]== BPos[1]):
		$"Highlight-offcursor".visible = true
		$"Highlight-offcursor".get_surface_override_material(0).set_shader_parameter("Text", highlightTile)
		#WORKS!!!
		#$"Highlight-offcursor".get_surface_override_material(0).set_shader_parameter("Text", summonTile)
	if(curpos[0] == BPos[0] and curpos[1]== BPos[1]):
		$Highight.visible = true
		$"Highlight-offcursor".visible = false
	pass
