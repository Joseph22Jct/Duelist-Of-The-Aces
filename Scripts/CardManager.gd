extends Node3D

var Card = preload("res://Objects/card_Piece.tscn")
var CardPiece = preload("res://Objects/card_Piece.tscn")

# Called when the node enters the scene tree for the first time.
func SpawnCard(type, value):
	var curCard = Card.instantiate()
	##TODO Set up the curCard Textures

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#var AFace = preload("")
#var TwoFace = preload("")
#var ThreeFace = preload("")
#var FourFace = preload("")
#var FiveFace = preload("")
#var SixFace = preload("")
#var SevenFace = preload("")
#var EightFace = preload("")
#var NineFace = preload("")
#var TenFace = preload("")
#var JackFace = preload("")
#var QueenFace = preload("")
#var KingFace = preload("")
#var NBG = preload("")
#var DBG = preload("")
#var HBG = preload("")
#var CBG = preload("")
#var SBG = preload("")
