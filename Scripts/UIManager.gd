extends Control

class_name UIManager
var CardObj = preload("res://Objects/card.tscn")
var cylinderSelect = preload("res://Sprites/cylinder_select.tscn")
var FusionFlagobj = preload("res://Sprites/FusionFlags.tscn")
var CamOffset = Vector3(-3,0.5,-3.7) #(-3,4.4,8)
var FusionQueue = []
var Cards 
var CurCardSelect = 0
var cS
var hasSummoned = false
var ComM : CombatManager

func _ready():
	Globals.UIManager = self
	Cards = Node3D.new()
	ComM = Globals.CombatManager
	pass
	
func StartFight(init:CardBase, foe:CardBase):
	Globals.SoundManager.PlaySoundEffect("CombatStart")
	Globals.Camera.add_child(Cards)
	Cards.position = CamOffset + Vector3(3,0,0)
	var card = Globals.CardManager.SpawnCard(init)
	var foeCard =  Globals.CardManager.SpawnCard(foe)
	Cards.add_child(card)
	card.rotation_degrees = Vector3(90,-180,0)
	card.position = Vector3(-1.5,0,0)
	Cards.add_child(foeCard)
	foeCard.rotation_degrees = Vector3(90,-180,0)
	foeCard.position = Vector3(1.5,0,0)
	print(str(ComM.curTerrainAdvantage) + " and type: " + str(ComM.curTypeAdvantage))
	
	var tween = get_tree().create_tween()
	var tween2 = get_tree().create_tween()
	Globals.SoundManager.PlaySoundEffect("CombatDone")
	if(ComM.curTerrainAdvantage!=0 or ComM.curTypeAdvantage!=0):
		if(ComM.curTerrainAdvantage==1):
			tween.tween_property($Bonuses/P1/Terrain, "position", Vector2(300,0),0.5)
		elif(ComM.curTerrainAdvantage==-1):
			tween.tween_property($Bonuses/P2/Terrain, "position", Vector2(-300,0),0.5)
		else:
			tween.tween_property($Bonuses/P1/Terrain, "position", Vector2(0,0),0.5)
		if(ComM.curTypeAdvantage == 1):
			tween2.tween_property($Bonuses/P1/Type, "position", Vector2(300,200),0.5)
		elif(ComM.curTypeAdvantage == -1):
			tween2.tween_property($Bonuses/P2/Type, "position", Vector2(-300,200),0.5)
		else:
			tween2.tween_property($Bonuses/P1/Type, "position", Vector2(0,0),0.5)
		await tween.finished
		print("Pt1 Done")
	tween = get_tree().create_tween()
	tween.tween_property($Bonuses/P1/Terrain, "scale", Vector2(1,1),0.5)
	await tween.finished
	print("Pt2 Done")
	if(ComM.curTerrainAdvantage!=0 or ComM.curTypeAdvantage!=0):
		tween = get_tree().create_tween()
		tween2 = get_tree().create_tween()
		if(ComM.curTerrainAdvantage==1):
			tween.tween_property($Bonuses/P1/Terrain, "position", Vector2(0,0),0.5)
		elif(ComM.curTerrainAdvantage==-1):
			tween.tween_property($Bonuses/P2/Terrain, "position", Vector2(0,0),0.5)
		else:
			tween.tween_property($Bonuses/P1/Terrain, "position", Vector2(0,0),0.5)
		if(ComM.curTypeAdvantage == 1):
			tween2.tween_property($Bonuses/P1/Type, "position", Vector2(0,200),0.5)
		elif(ComM.curTypeAdvantage == -1):
			tween2.tween_property($Bonuses/P2/Type, "position", Vector2(0,200),0.5)
		else:
			tween2.tween_property($Bonuses/P1/Type, "position", Vector2(0,0),0.5)
		await tween.finished
	var result
	var DamageDealt = 0
	if(init.number+ ComM.curTerrainAdvantage + ComM.curTypeAdvantage > foe.number or init.number == 1):
		if(init.number == 1):
			DamageDealt = 0
		else:
			DamageDealt = init.number+ ComM.curTerrainAdvantage + ComM.curTypeAdvantage - foe.number
		$DamageDealt.visible = true
		$DamageDealt.text = "Dealt "+ str(DamageDealt)+ " damage to foe!"
		result = 1
		tween = get_tree().create_tween()
		tween.tween_property(card, "position", foeCard.position,0.3).set_trans(Tween.TRANS_SINE)
		
		await tween.finished
		Globals.SoundManager.PlaySoundEffect("Confirm")
		tween = get_tree().create_tween()
		tween.tween_property(foeCard, "position", Vector3(15,0,0),0.2).set_trans(Tween.TRANS_LINEAR)
		await tween.finished
		pass
	elif(init.number+ ComM.curTerrainAdvantage + ComM.curTypeAdvantage < foe.number):
		DamageDealt = init.number+ ComM.curTerrainAdvantage + ComM.curTypeAdvantage - foe.number
		$DamageDealt.visible = true
		$DamageDealt.text = "Received "+ str(DamageDealt)+ " damage..."
		result = -1
		tween = get_tree().create_tween()
		tween.tween_property(foeCard, "position", card.position,0.3).set_trans(Tween.TRANS_SINE)
		await tween.finished
		Globals.SoundManager.PlaySoundEffect("Confirm")
		tween = get_tree().create_tween()
		tween.tween_property(card, "position", Vector3(-15,0,0),0.2).set_trans(Tween.TRANS_LINEAR)
		await tween.finished
		pass
	else:
		result = 0
		$DamageDealt.visible = true
		$DamageDealt.text = "Both cards eliminated. No Damage."
		tween = get_tree().create_tween()
		tween.tween_property(foeCard, "position", Vector3.ZERO,0.3).set_trans(Tween.TRANS_SINE)
		tween2 = get_tree().create_tween()
		tween2.tween_property(card, "position", Vector3.ZERO,0.3).set_trans(Tween.TRANS_SINE)
		await tween.finished
		Globals.SoundManager.PlaySoundEffect("Confirm")
		tween = get_tree().create_tween()
		tween.tween_property(card, "position", Vector3(-10,0,0),0.3).set_trans(Tween.TRANS_LINEAR)
		tween2 = get_tree().create_tween()
		tween2.tween_property(foeCard, "position", Vector3(10,0,0),0.3).set_trans(Tween.TRANS_LINEAR)
		
		await tween.finished
	tween = get_tree().create_tween()
	tween.tween_property($Bonuses/P1/Terrain, "scale", Vector2(1,1),0.5)
	await tween.finished
	tween = get_tree().create_tween()
	if(result == -1):
		tween.tween_property(foeCard, "position", Vector3(0,10,0),0.3).set_trans(Tween.TRANS_LINEAR)
		await tween.finished
	elif(result == 1):
		tween.tween_property(card, "position", Vector3(0,10,0),0.3).set_trans(Tween.TRANS_LINEAR)
		await tween.finished
	$DamageDealt.visible = false
	
	if(DamageDealt>0 and GameManager.curPhase == 1):
		GameManager.UpdateScore(2, -DamageDealt,0,0)
	elif(DamageDealt>0 and GameManager.curPhase == 2):
		GameManager.UpdateScore(1, -DamageDealt,0,0)
	if(DamageDealt<0 and GameManager.curPhase == 1):
		GameManager.UpdateScore(1, -DamageDealt,0,0)
	elif(DamageDealt<0 and GameManager.curPhase == 2):
		GameManager.UpdateScore(2, -DamageDealt,0,0)
	Globals.SoundManager.PlaySoundEffect("Confirm")
	Globals.BoardManager.FightAftermath(result)
	#TODO;
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
			if(not hasSummoned):
				if(FusionQueue!=[]):
					if(GameManager.GetCurPhaseAP()<Globals.CardManager.GetCurrentHand()[FusionQueue[0]].number):
						Globals.SoundManager.PlaySoundEffect("Cannot")
						return
					pass
				else:
					if(GameManager.GetCurPhaseAP()<Globals.CardManager.GetCurrentHand()[CurCardSelect].number):
						Globals.SoundManager.PlaySoundEffect("Cannot")
						return
				justPressed = true
				Globals.GameManager.ChangeState("ConfirmCards")
				Globals.SoundManager.PlaySoundEffect("Confirm")
				ConfirmCards(CurCardSelect)
			else:
				Globals.SoundManager.PlaySoundEffect("Cannot")
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
	hasSummoned = true
	
	
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
			
	if Player != 1:
		
		$Scores/ScoreP2/Scores/Health.text = str(values[0])
	
		$Scores/ScoreP2/Scores/AP.text = str(values[1])
	
		$Scores/ScoreP2/Scores/Cards.text = str(values[2])
# Called when the node enters the scene tree for the first time.
