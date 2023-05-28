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
	for x in $FusionFlags.get_children():
		x.queue_free()
	FusionQueue = []
	justPressed = false

var justPressed = false
func _process(delta):
	
	
	if(Globals.GameManager.cState == "ShowCards"):
		if(Input.is_action_just_pressed("Left")):
			CurCardSelect -=1 
			if(CurCardSelect == -1):
				CurCardSelect = 4
			MoveCursor(CurCardSelect)
			Globals.SoundManager.PlaySoundEffect("CursorMove")
			
		if(Input.is_action_just_pressed("Right")):
			CurCardSelect +=1 
			if(CurCardSelect == 5):
				CurCardSelect = 0
			MoveCursor(CurCardSelect)
			Globals.SoundManager.PlaySoundEffect("CursorMove")
		
		if(Input.is_action_just_pressed("Cancel")):
			Globals.GameManager.ChangeState("Summon")
			Globals.SoundManager.PlaySoundEffect("Cancel")
			
		if(Input.is_action_just_pressed("SummonFlip")):
			ToggleFusionFlag(CurCardSelect)
			Globals.SoundManager.PlaySoundEffect("FuseSelect")
			pass
		
		if(Input.is_action_just_pressed("Confirm") and not justPressed):
			justPressed = true
			Globals.GameManager.ChangeState("ConfirmCards")
			Globals.SoundManager.PlaySoundEffect("Confirm")
			ConfirmCards(CurCardSelect)
			return
			
			
		justPressed = false
		
	elif(Globals.GameManager.cState == "ConfirmCards"):
		#print("StateChanged!")
		if(Input.is_action_just_pressed("Cancel")):
			Globals.GameManager.ChangeState("ShowCards")
			Globals.SoundManager.PlaySoundEffect("Cancel")
			CancelCards()
		pass
		if(Input.is_action_just_pressed("Confirm")):
			
			Globals.GameManager.ChangeState("Fuse")
			Globals.SoundManager.PlaySoundEffect("Confirm")
			FuseCards()
			return
			
		
	pass
	
var FusedCard
func FuseCards():
	cS.visible = false
	for x in $FusionFlags.get_children():
		x.queue_free()
	if(FusionQueue==[]):
		FusionQueue.append(CurCardSelect)
		
	if(Globals.GameManager.curPhase == 1):
		GameManager.UpdateScore(GameManager.curPhase, null,-Globals.CardManager.Hand1[FusionQueue[0]].number,null)
	else:
		GameManager.UpdateScore(GameManager.curPhase, null,- Globals.CardManager.Hand2[FusionQueue[0]].number,null)
	var CardsCh = Cards.get_children()
#	if(len(FusionQueue) == 0):
#		Cards.move_child(CardsCh[CurCardSelect], 0)
	if(len(FusionQueue)>1):
		var GetCardsToFuse = []
		for x in FusionQueue:
			if(Globals.GameManager.curPhase == 1):
				GetCardsToFuse.append(Globals.CardManager.Hand1[x])
			else:
				GetCardsToFuse.append(Globals.CardManager.Hand2[x])
		
		var curFusion = 1
		while(len(GetCardsToFuse)>1):
			
			FusedCard = Globals.CardManager.Fuse(GetCardsToFuse[0],GetCardsToFuse[1])
			print("Fused Cards: " + str(GetCardsToFuse[0].number)+ "+"+ str(GetCardsToFuse[1].number)+ "= "+ str(FusedCard.number)+ " of type: "+str(FusedCard.type))
			GetCardsToFuse[0] = FusedCard
			GetCardsToFuse.pop_at(1)
			CardsCh = Cards.get_children()
			
			var newPos = Vector3(3,0.4,0)
			print(str(FusionQueue[0])+ " + "+ str(FusionQueue[curFusion]))
			print(CardsCh)
			var tween2 = get_tree().create_tween()
			Globals.SoundManager.PlaySoundEffect("Fusion")
			if(curFusion==1):
				var tween = get_tree().create_tween()
				tween.tween_property(CardsCh[FusionQueue[0]], "position", newPos+ Vector3(0,0,0.1) , 0.5)
				
				tween2.tween_property(CardsCh[FusionQueue[curFusion]], "position", newPos , 0.5)
			else:
				
				tween2.tween_property(CardsCh[FusionQueue[curFusion]+1], "position", newPos , 0.5)
			await tween2.finished
			SpawnFusedCard()
			
			
			curFusion+=1
			pass
		CardsCh = Cards.get_children()
		for x in range(len(CardsCh)):
			if x == 0:
				continue
			else:
				CardsCh[x].queue_free()
		
		var tween = get_tree().create_tween()
		tween.tween_property(CardsCh[0], "position", CardsCh[0].position+ Vector3(0,5,0.1) , 0.5)
		await tween.finished
		##PlaceCard On Field
		print(CardsCh[0].GetCard())
		Globals.SoundManager.PlaySoundEffect("SummonCard")
		Globals.CardManager.UseCards(FusionQueue)
		
		Globals.CardManager.SummonCard(Globals.Cursor.curPos, CardsCh[0].GetCard())
	else:
		var tween = get_tree().create_tween()
		tween.tween_property(CardsCh[FusionQueue[0]], "position", CardsCh[FusionQueue[0]].position+ Vector3(0,5,0.1) , 0.5)
		await tween.finished
		##PlaceCard On Field
		print(CardsCh[0].GetCard())
		Globals.SoundManager.PlaySoundEffect("SummonCard")
		Globals.CardManager.UseCards(FusionQueue)
		Globals.CardManager.SummonCard(Globals.Cursor.curPos, CardsCh[FusionQueue[0]].GetCard())
	GameManager.ChangeState("Main")
	HideCards()
	
	
func SpawnFusedCard():
	Cards.get_children()[0].queue_free()
	var newCard = Globals.CardManager.SpawnCard(FusedCard)
	Cards.add_child(newCard)
	newCard.position = Vector3(3,0.4,0.1)
	newCard.rotation_degrees = Vector3(90,-180,0)
	Cards.move_child(newCard,0)
	
	
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
	
var RemovedCards = []

func ConfirmCards(cur):
	
	if(FusionQueue==[]):
		var CardCh = Cards.get_children()
		for x in range(len(CardCh)):
			if(x!=cur):
				if(CardCh[x]!=cS):
					RemovedCards.append(x)
					CardCh[x].position
					var tween = get_tree().create_tween()
					tween.tween_property(CardCh[x], "position", Vector3( CardCh[x].position.x,-5, CardCh[x].position.z), 0.3).set_trans(Tween.TRANS_SINE)
	else:
		var CardCh = Cards.get_children()
		for x in range(len(CardCh)):
			if(x not in FusionQueue):
				if(CardCh[x]!=cS):
					RemovedCards.append(x)
					CardCh[x].position
					var tween = get_tree().create_tween()
					tween.tween_property(CardCh[x], "position", Vector3( CardCh[x].position.x,-5, CardCh[x].position.z), 0.3).set_trans(Tween.TRANS_SINE)
		
	pass

func CancelCards():
	var CardCh = Cards.get_children()
	for x in RemovedCards:
		var tween = get_tree().create_tween()
		tween.tween_property(CardCh[x], "position", Vector3( CardCh[x].position.x,0, CardCh[x].position.z), 0.3).set_trans(Tween.TRANS_SINE)
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
