extends Node3D

var cState = "Standby"
var Player1Score = [20,8,0]
var Player2Score = [20,8,0]
var turnCount = 1
var curPhase = 1
var MainMenuObject
var GameplayObject
var SelectedBoard = 0


func GetCurPhaseAP():
	if(curPhase == 1):
		return Player1Score[1]
	else:
		return Player2Score[1] 
func UpdateScore(which, Health = null, AP = null, Deck = null):
	if which ==1:
		if(Health!=null):
			Player1Score[0]+=Health
		if(AP!=null):
			Player1Score[1]+=AP
		if(Deck!=null):
			Player1Score[2]+=Deck
	else:
		if(Health!=null):
			Player2Score[0]+=Health
		if(AP!=null):
			Player2Score[1]+=AP
		if(Deck!=null):
			Player2Score[2]+=Deck
	Globals.UIManager.SetScore(1, Player1Score)
	Globals.UIManager.SetScore(2, Player2Score)


# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.GameManager = self
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	call(cState)
	pass

func Main():
	if(Input.is_action_just_pressed("Start") and curPhase == 1):
		ChangeState("EndTurn")
	pass
#	if(Input.is_action_just_pressed("SummonFlip")):
#		ChangeState("Summon")
	#print("OK!")
	pass
	
func Summon():
	if(Input.is_action_just_pressed("Cancel")):
		ChangeState("Main")
	
	

func ShowCards():
	if(Input.is_action_just_pressed("Cancel")):
		ChangeState("Summon")
	pass
	
func ConfirmCards():
	
	pass
	
func Fuse():
	
	pass
	
func MovePiece():
	if(Input.is_action_just_pressed("Cancel")):
		Globals.Cursor.CancelMov()
		ChangeState("Main")
	pass

func PieceMovement():
	pass
	
func Combat():
	pass

func EndTurn():
	pass

func EndGame():
	
	pass
func Standby():
	pass
	
func ChangeState(state):
	
	match state:
		"Standby":
			cState = "Standby"
		"Main":
			if(cState == "Combat"):
				if(Player1Score[0]<=0):
					ChangeState("EndGame")
					return
				elif(Player2Score[0]<=0):
					ChangeState("EndGame")
					return
				pass
			cState = "Main"
			Globals.BoardManager.CancelTiles()
			Globals.Cursor.ToggleCursor(true)
		"Summon":
			cState = "Summon"
			Globals.BoardManager.ShowSummonableTiles()
			Globals.Cursor.ToggleCursor(true)
			Globals.UIManager.HideCards()
		"ShowCards":
			if(cState == "ConfirmCards"):
				cState = "ShowCards"
				return
			cState = "ShowCards"
			Globals.UIManager.ShowCards()
			Globals.Cursor.ToggleCursor(false)
		"ConfirmCards":
			cState = "ConfirmCards"
		"Fuse":
			cState = "Fuse"
		"MovePiece":
			cState = "MovePiece"
			Globals.BoardManager.ShowTraversibleTiles()
		"PieceMovement":
			cState = "PieceMovement"
		"Combat":
			cState = "Combat"
			Globals.Cursor.ToggleCursor(false)
			Globals.BoardManager.CancelTiles()
		"EndTurn":
			cState= "EndTurn"
			Globals.SoundManager.PlaySoundEffect("TurnOver")
			Globals.Cursor.ToggleCursor(false)
			Globals.UIManager.ToggleSummon(false)
			UpdateScore(curPhase,0,4,0)
			Globals.BoardManager.RefreshCards()
			
			if curPhase ==1:
				curPhase = 2
				Globals.AIManager.turnEnded = false
			else:
				curPhase = 1
				turnCount+=1
				Globals.UIManager.UpdateTurn(turnCount)
				
			if(turnCount == 21):
				ChangeState("EndGame")
			Globals.CardManager.FillHands(curPhase)
			Globals.Camera.CameraShift(curPhase)
		"EndGame":
			
			var winner = DetermineWinner()
			cState = "EndGame"
			Globals.UIManager.Celebrate(winner)
			##TODO Show some animation first
			
			
func DetermineWinner():
	if(Player1Score[0] <0):
		return -1
	elif(Player2Score[0]<0):
		return 1
	
	var pieces = Globals.CardManager.PieceHolder.get_children()
	var curP1 = 0
	var curP2 = 0
	for x in pieces:
		if x.POwner==1:
			curP1+=1
		else:
			curP2+=1
	if (curP1>curP2):
		return 1
	else:
		return -1

func FinishAll():
	GameplayObject.queue_free()
	GameplayObject = null
	GameplayObject = preload("res://Objects/main_menu.tscn").instantiate()
	add_child(GameplayObject)
	ChangeState("Standby")
