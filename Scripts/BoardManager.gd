extends Node3D
class_name BoardManager
var Map = []
var BoardType = 0
var BoardTiles = preload("res://Objects/board_tile.tscn")
var CardP= preload("res://Objects/card_Piece.tscn")
var P1LeaderPiece
var P2LeaderPiece
# Called when the node enters the scene tree for the first time.

func GetPiecesWithinSpaces(pos, amount):
	var Pieces = []
	for x in range(len(Map)):
		for y in range(len(Map[0])):
			if DistanceAway(pos, [x,y])<=amount:
				if(Map[x][y].Piece!=null):
					Pieces.append(Map[x][y])
	return Pieces
			
			
func SetBoard():
	match GameManager.SelectedBoard:
		#Map[3][3].SetType(0)
		0:
			
			for x in range(7):
				Map[x][4].SetType(5)
				Map[x][5].SetType(6)
				Map[x][1].SetType(3)
				Map[x][2].SetType(4)
				
			for x in range(7):
				
				Map[2][x].SetType(1)
				Map[4][x].SetType(2)
				
			for x in range(7):
				Map[3][x].SetType(0)
		1:
			for x in range(7):
				for y in range(7):
					Map[x][y].SetType(x)
		2:
			for x in range(7):
				Map[x][0].SetType(2) 
				Map[x][2].SetType(2) 
				Map[x][4].SetType(2) 
				Map[x][6].SetType(2) 
				Map[x][1].SetType(1) 
				Map[x][3].SetType(1)
				Map[x][5].SetType(1)  
		3:
			for x in range(7):
				for y in range(7):
					
					Map[x][y].SetType((x+y)/2)
		4:
			for x in range(7):
				Map[0][x].SetType(2) 
				Map[2][x].SetType(2) 
				Map[4][x].SetType(2) 
				Map[6][x].SetType(2) 
				Map[1][x].SetType(1) 
				Map[3][x].SetType(1)
				Map[5][x].SetType(1)  
		5:
			for x in range(7):
				for y in range(7):
					randomize()
					Map[x][y].SetType(randi_range(0,6))

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
			
	SetBoard()
	
	await get_tree().process_frame
	var MC1 = CardBase.new()
	MC1.number = 0
	MC1.type = 0
	var MC2 = CardBase.new()
	MC2.number = 0
	MC2.type = 0
	Globals.CardManager.SummonCard([3,6],MC1,1)
	Globals.CardManager.SummonCard([3,0],MC2,2)
	var ch = Globals.CardManager.PieceHolder.get_children()
	print(ch)
	P1LeaderPiece = ch[0]
	P2LeaderPiece = ch[1]
	P1LeaderPiece.ToggleWait(false)
	P2LeaderPiece.ToggleWait(false)
#	P1LeaderPiece = CardP.instantiate()
#	#Map[3][6].Piece = P1LeaderPiece
#	P1LeaderPiece.SetUp(0,0,1,[3,6])
#	P2LeaderPiece = CardP.instantiate()
#	#Map[3][0].Piece = P2LeaderPiece
#	P2LeaderPiece.SetUp(0,0,2,[3,0])
	$CardPieces.add_child(P1LeaderPiece)
	$CardPieces.add_child(P2LeaderPiece)
	await get_tree().process_frame
	CancelTiles()
#	var Card1 = CardBase.new()
#	Card1.type = 1
#	Card1.number = 6
#	Globals.CardManager.SummonCard([3,3],Card1, 2)
	pass # Replace with function body.

func FuseBoardCards(initTile:BoardTile, foeTile:BoardTile): #FuseBoardCards( curTileSelectedMov, GetCurBoardTile())
	
	var pos = foeTile.BPos
	var initC = CardBase.new()
	initC.type = initTile.Piece.type
	initC.number = initTile.Piece.number
	var foeC = CardBase.new()
	foeC.type = foeTile.Piece.type
	foeC.number = foeTile.Piece.number
	var C:CardBase = Globals.CardManager.Fuse(initC, foeC)
	initTile.Piece.queue_free()
	initTile.Piece = null
	foeTile.Piece.queue_free()
	foeTile.Piece = null
	Globals.CardManager.SummonCard(pos, C)
	
	pass
	
func RefreshCards():
	var pieces = $CardPieces.get_children()
	for x in pieces:
		x.ToggleWait(false)
	pass

func MovePiece(PieceTile, newPos):
	Globals.SoundManager.PlaySoundEffect("PlaceCard")
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
	print("Hey")
	
	pass
	
func FightAftermath(result):
	print("Fight Done!")
	var initTile:BoardTile = Globals.CombatManager.InitiatingTile
	var foeTile:BoardTile = Globals.CombatManager.currentCombatTile
	if(foeTile.Piece.type == 0):
		GameManager.ChangeState("Main")
		return
	if result==1: ##Init won
		foeTile.Piece.queue_free()
		foeTile.Piece = null
		MovePiece(initTile,foeTile.BPos)
		pass
	elif result == -1: ##foe won
		initTile.Piece.queue_free()
		initTile.Piece = null
		
		pass
	else: ##Neither did
		initTile.Piece.queue_free()
		initTile.Piece = null
		foeTile.Piece.queue_free()
		foeTile.Piece = null
		pass
	
	GameManager.ChangeState("Main")
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
			
	for y in range(len(Map)):
		for x in range(len(Map[0])):
			if(Map[x][y].Actionable == true and DistanceAway(cPos, [x,y])==2):
				var xDist = x-cPos[0] 
				var yDist = y-cPos[1]
				if(abs(xDist)==2):
					xDist-= sign(xDist)
					if(Map[x-xDist][y].Piece != null):
						Map[x][y].Actionable = false
					pass
				elif(abs(yDist)==2):
					yDist-= sign(yDist)
					if(Map[x][y-yDist].Piece != null):
						Map[x][y].Actionable = false
					pass
				elif(abs(xDist)==1 and abs(yDist)==1):
					if(Map[x][y-yDist].Piece != null and Map[x-xDist][y].Piece != null):
						Map[x][y].Actionable = false
					pass
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
