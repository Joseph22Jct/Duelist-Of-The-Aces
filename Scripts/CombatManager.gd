extends Node3D

class_name CombatManager
var BM: BoardManager 
var UIM: UIManager
var curTypeAdvantage = 0
var curTerrainAdvantage = 0 
var currentCombatTile = null

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.CombatManager = self
	await get_tree().process_frame
	BM = Globals.BoardManager
	UIM = Globals.UIManager
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func StartCombat(initPiece:CardPiece,foePiece:CardPiece, combatTile:BoardTile):
	if(not initPiece.flipped):
		initPiece.flipped = true
		initPiece.flipCard()
	if(not foePiece.flipped):
		foePiece.flipped = true
		foePiece.flipCard()
	var Card1 = CardBase.new()
	var Card2 = CardBase.new()
	Card1.type = initPiece.type
	Card2.type = foePiece.type
	Card1.number = initPiece.number
	Card2.number = foePiece.number
	currentCombatTile = combatTile
	curTypeAdvantage = CheckTypeAdvantage(Card1.type, Card2.type)
	curTerrainAdvantage = CheckTerrainAdvantage(initPiece)
	UIM.StartFight(Card1,Card2)
	pass

func CheckTypeAdvantage(inittype, foetype): ##1 means advanta, 0 neutral, -1 disadvantage
	if(foetype == inittype-1):
		return 1
	elif(inittype == foetype-1):
		return -1
	if(inittype==1 and foetype == 4):
		return 1
	if(foetype == 1 and inittype == 4):
		return -1
	
	return 0	
	pass
func CheckTerrainAdvantage(piece1): #1 means P1 has advantage, -1 means foe has advantage, 0 means both have terrain bonus or none
	var b1 = BM.isFavorableTerrain(currentCombatTile, piece1)
	var b2 = BM.isFavorableTerrain(currentCombatTile)
	if(b1 and not b2):
		return 1
	elif(not b1 and b2):
		return -1
	else:
		return 0
	pass
	
