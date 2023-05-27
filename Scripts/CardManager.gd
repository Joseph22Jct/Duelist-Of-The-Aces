extends Node3D

class_name CardManager
var Card = preload("res://Objects/card.tscn")
var CardPiece = preload("res://Objects/card_Piece.tscn")

var Deck1 = []
var Deck2 = []

var Hand1 = []
var Hand2 = []

func _ready():
	Globals.CardManager = self
	await get_tree().process_frame
	CreateDecks()
	
func CreateDecks():
	
	for type in range(5):
		if(type == 0):
			continue
		for number in range(14):
			if number == 0:
				continue
			var C:CardBase = CardBase.new()
			C.type = type
			C.number = number
			Deck1.append(C)
			C = CardBase.new()
			C.type = type
			C.number = number
			Deck2.append(C)
	Globals.GameManager.UpdateScore(1,null,null, len(Deck1))
	Globals.GameManager.UpdateScore(2,null,null, len(Deck2))
	FillHands(1)
	FillHands(2)
	pass
	
func FillHands(which):
	if which == 1:
		
		while (len(Hand1)<5 and len(Deck1 )> 0):
			Hand1.append(DrawCard(1))
			pass
	else:
		while (len(Hand2)<5 and len(Deck2 )> 0):
			Hand2.append(DrawCard(2))
			pass
	
func DrawCard(which):
	randomize()
	if which == 1:
		Globals.GameManager.UpdateScore(1,null,null, -1)
		return Deck1.pop_at(randi()%Deck1.size())
	else:
		Globals.GameManager.UpdateScore(2,null,null, -1)
		return Deck2.pop_at(randi()%Deck2.size())
	pass

# Called when the node enters the scene tree for the first time.
func SpawnCard(C:CardBase = null, type = null, number = null): ##Type 0 makes Blank. 
	var curCard = Card.instantiate()
	var cType = 0
	var value = 0
	var typetexture = null
	var numTexture = null
	if C!=null:
		cType = C.type
		value = C.number
	else:
		cType = type
		value = number
		
	match cType:
		0: ##Blank
			typetexture = NBG
		1: 
			typetexture = DBG
		2: 
			typetexture = HBG
		3: 
			typetexture = CBG
		4: 
			typetexture = SBG
	
	match value:
		0:
			numTexture = NBG
		1: 
			numTexture = AFace
		2: 
			numTexture = TwoFace
		3: 
			numTexture = ThreeFace
		4: 
			numTexture = FourFace
		5: 
			numTexture = FiveFace
		6: 
			numTexture =SixFace
		7: 
			numTexture =SevenFace
		8: 
			numTexture =EightFace
		9: 
			numTexture =NineFace
		10: 
			numTexture =TenFace
		11: 
			numTexture =JackFace
		12: 
			numTexture =QueenFace
		13: 
			numTexture =KingFace
			
			
		
	
	curCard.type = cType
	curCard.num = value
	curCard.SetCard(typetexture, numTexture)
	return curCard

	
	
func SpawnPiece(C:CardBase = null, type = null, number = null): ##Type 0 make leader. 
	var curPiece = CardPiece.instantiate()
	##TODO Set up the curCard Textures

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

var AFace = preload("res://Sprites/Cards/Numbers2.png")
var TwoFace = preload("res://Sprites/Cards/Numbers3.png")
var ThreeFace = preload("res://Sprites/Cards/Numbers4.png")
var FourFace = preload("res://Sprites/Cards/Numbers5.png")
var FiveFace = preload("res://Sprites/Cards/Numbers6.png")
var SixFace = preload("res://Sprites/Cards/Numbers7.png")
var SevenFace = preload("res://Sprites/Cards/Numbers8.png")
var EightFace = preload("res://Sprites/Cards/Numbers9.png")
var NineFace = preload("res://Sprites/Cards/Numbers10.png")
var TenFace = preload("res://Sprites/Cards/Numbers11.png")
var JackFace = preload("res://Sprites/Cards/Numbers12.png")
var QueenFace = preload("res://Sprites/Cards/Numbers13.png")
var KingFace = preload("res://Sprites/Cards/Numbers14.png")
var NBG = preload("res://Sprites/Cards/Cards6.png")
var DBG = preload("res://Sprites/Cards/Cards2.png")
var HBG = preload("res://Sprites/Cards/Cards3.png")
var CBG = preload("res://Sprites/Cards/Cards4.png")
var SBG = preload("res://Sprites/Cards/Cards5.png")
