extends Node3D
class_name BoardManager
var Map = []
var BoardTiles = preload("res://Objects/board_tile.tscn")
var CardP= preload("res://Objects/card_Piece.tscn")
var P1LeaderPiece
var P2LeaderPiece
# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.BoardManager = self
	for x in range(7):
		Map.append([])
		for y in range(7):
			var BT= BoardTiles.instantiate()
			$Tiles.add_child(BT)
			BT.position = Vector3((x-3)*2,0.6,(y-3)*2)
			Map[x].append(BT)
			BT.BPos = [x,y]
			BT.SetType(x)
	P1LeaderPiece = CardP.instantiate()
	Map[3][6].Piece = P1LeaderPiece
	P1LeaderPiece.SetUp(0,0,1,[3,6])
	P2LeaderPiece = CardP.instantiate()
	Map[3][0].Piece = P2LeaderPiece
	P2LeaderPiece.SetUp(0,0,2,[3,0])
	$CardPieces.add_child(P1LeaderPiece)
	$CardPieces.add_child(P2LeaderPiece)
	await get_tree().process_frame
	var Card1 = CardBase.new()
	Card1.type = 1
	Card1.number = 6
	Globals.CardManager.SummonCard([3,3],Card1, 2)
	pass # Replace with function body.

func MovePiece(PieceTile, newPos):
	
	#CheckForCombats
	var piece = PieceTile.Piece
	piece.BPos = newPos
	PieceTile.Piece = null
	Map[newPos[0]][newPos[1]].Piece = piece
	piece.position = Vector3(Map[newPos[0]][newPos[1]].position.x, piece.position.y, Map[newPos[0]][newPos[1]].position.z)
	if(piece.CardObj!=null):
		piece.CardObj.position = Vector3.ZERO
	print("Code reached")
	piece.ToggleWait(true)
	
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Boardblend/icons.rotate_y(delta*0.2)
	pass

func ShowSummonableTiles():
	var leader
	if Globals.GameManager.curPhase ==1:
		leader = P1LeaderPiece
	else: 
		leader = P2LeaderPiece
		
	print(leader.BPos)
	for y in range(len(Map)):
		for x in range(len(Map[0])):
			Map[x][y].Summon = true
			
			if(Map[x][y].BPos[1] <= leader.BPos[1]+1 and Map[x][y].BPos[1] >= leader.BPos[1]-1): #[3,3] , [3,5] ->
				if(Map[x][y].BPos[0] <= leader.BPos[0]+1 and Map[x][y].BPos[0] >= leader.BPos[0]-1): #[3,3] ->
					
					print(str(Map[x][y].BPos)+" Actionable!")
					#print(str(Map[x][y].BPos[1]) +" >= "+ str(leader.BPos[1])+ "-1") 
					if(Map[x][y].Piece==null):
						Map[x][y].Actionable = true 

			if(Map[x][y].BPos[0] == leader.BPos[0] and Map[x][y].BPos[1] == leader.BPos[1]):
				Map[x][y].Actionable = false
			Map[x][y].CheckHighlight()
	pass
	
func ShowTraversibleTiles(): ##Repeat when flipped and unflipped
	var PieceTile:BoardTile = Globals.Cursor.GetCurBoardTile()
	
		
	print(PieceTile.BPos)
	var cPos = PieceTile.BPos
	
	
	for y in range(len(Map)):
		for x in range(len(Map[0])):
			Map[x][y].Movement = true
			Map[x][y].Actionable = false
			if(isFavorableTerrain(PieceTile)):
				if(DistanceAway(cPos, Map[x][y].BPos)<=2):
					Map[x][y].Actionable = true
			else:
				if(DistanceAway(cPos, Map[x][y].BPos)<=1):
					Map[x][y].Actionable = true
			Map[x][y].CheckHighlight()
	
	
	pass
	
func isFavorableTerrain(PieceTile: BoardTile, Piece = null):
	var TerrainType = PieceTile.TerrainType
	if(Piece == null):
		Piece = PieceTile.Piece
	var cType = Piece.type
	var cNumber = Piece.number
	var flipped = Piece.flipped
	
	if(not flipped):
		return false
	
	match TerrainType:
		0:
			return false
		1:
			if(cNumber%2 ==1):
				return true
		2:
			if(cNumber%2 ==0):
				return true
		3:
			if(cType == 1):
				return true
		4:
			if(cType == 2):
				return true
		5:
			if(cType == 3):
				return true
		6:
			if(cType == 4):
				return true
	
	return false
	
	pass

func DistanceAway(posA, posB):
	return abs(posB[0]-posA[0])+abs(posB[1]-posA[1])

	
	
func CancelTiles():
	for row in Map:
		for tile in row:
			tile.Summon = false
			tile.Actionable = false
			tile.Movement = false
			tile.CheckHighlight()
