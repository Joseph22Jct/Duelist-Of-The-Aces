extends Node3D

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
	P1LeaderPiece.SetUp(0,0,1,[3,6])
	P2LeaderPiece = CardP.instantiate()
	P2LeaderPiece.SetUp(0,0,2,[3,0])
	$CardPieces.add_child(P1LeaderPiece)
	$CardPieces.add_child(P2LeaderPiece)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
					Map[x][y].Actionable = true 
			
				
				
				
			if(Map[x][y].BPos[0] == leader.BPos[0] and Map[x][y].BPos[1] == leader.BPos[1]):
				Map[x][y].Actionable = false
			Map[x][y].CheckHighlight()
	pass
	
func CancelTiles():
	for row in Map:
		for tile in row:
			tile.Summon = false
			tile.Actionable = false
			tile.CheckHighlight()
