extends Control

var CardObj = preload("res://Objects/card.tscn")
var cylinderSelect = preload("res://Sprites/cylinder_select.tscn")
var FusionFlagobj = preload("res://Sprites/FusionFlags.tscn")
var CamOffset = Vector3(-3,0.5,-3.7) #(-3,4.4,8)
var FusionQueue = []
var Cards 
var CurCardSelect = 0
var cS

func _ready():
	Globals.UIManager = self
	Cards = Node3D.new()
	pass
	
func ShowCards():
	
	Globals.Camera.add_child(Cards)
	Cards.position = CamOffset
	for x in range(len(Globals.CardManager.Hand1)):
		var card = Globals.CardManager.SpawnCard(Globals.CardManager.Hand1[x])
		Cards.add_child(card)
		card.rotation_degrees = Vector3(90,-180,0)
		card.position = Vector3(x*1.5,0,0)
	cS = cylinderSelect.instantiate()
	Cards.add_child(cS)
	cS.position = Cards.get_child(0).position
	pass
	
func HideCards():
	Cards.queue_free()
	Cards = Node3D.new()
	CurCardSelect = 0
	
func _process(delta):
	if(Globals.GameManager.cState == "ShowCards"):
		if(Input.is_action_just_pressed("Left")):
			CurCardSelect -=1 
			if(CurCardSelect == -1):
				CurCardSelect = 4
			MoveCursor(CurCardSelect)
			
		if(Input.is_action_just_pressed("Right")):
			CurCardSelect +=1 
			if(CurCardSelect == 5):
				CurCardSelect = 0
			MoveCursor(CurCardSelect)
		
		if(Input.is_action_just_pressed("Cancel")):
			Globals.ChangeState("Summon")
			
		if(Input.is_action_just_pressed("SummonFlip")):
			ToggleFusionFlag(CurCardSelect)
			pass
		pass
		pass
	pass
	
func ToggleFusionFlag(cur):
	
	
	if (cur in FusionQueue):
		for x in $FusionFlags.get_children():
			x.queue_free()
		FusionQueue.erase(cur)
		print(FusionQueue)
		
		for x in range(len(FusionQueue)):
			var FF = FusionFlagobj.instantiate()
			$FusionFlags.add_child(FF)
			FF.get_child(0).text = str(x+1)
			FF.position = Vector2(165*FusionQueue[x],0)
	else:
		FusionQueue.append(cur)
		var FF = FusionFlagobj.instantiate()
		$FusionFlags.add_child(FF)
		FF.get_child(0).text = str(len(FusionQueue))
		FF.position = Vector2(165*cur,0)
		
	
	pass	
	
func MoveCursor(cur):
	cS.position = Cards.get_child(cur).position

func SetScore(Player, values):
	if Player == 1:
		
		$Scores/ScoreP1/Scores/Health.text = str(values[0])
	
		$Scores/ScoreP1/Scores/AP.text = str(values[1])
	
		$Scores/ScoreP1/Scores/Cards.text = str(values[2])
			
	if Player == 1:
		
		$Scores/ScoreP2/Scores/Health.text = str(values[0])
	
		$Scores/ScoreP2/Scores/AP.text = str(values[1])
	
		$Scores/ScoreP2/Scores/Cards.text = str(values[2])
# Called when the node enters the scene tree for the first time.
