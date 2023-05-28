extends Node3D

var cState = "Main"
var Player1Score = [20,8,0]
var Player2Score = [20,8,0]
var turnCount = 1
var curPhase = 1

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
#	if(Input.is_action_just_pressed("SummonFlip")):
#		ChangeState("Summon")
	#print("OK!")
	pass
	
func Summon():
	if(Input.is_action_just_pressed("Cancel")):
		ChangeState("Main")
	
	pass

func ShowCards():
	if(Input.is_action_just_pressed("Cancel")):
		ChangeState("Summon")
	pass
	
func ConfirmCards():
	
	pass
	
func Fuse():
	
	pass
	
	
func ChangeState(state):
	
	match state:
		"Main":
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
			
	
