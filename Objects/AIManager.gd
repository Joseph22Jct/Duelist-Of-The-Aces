extends Node3D

var ActionQueue = []
var BM:BoardManager
var Pathfind : Pathfinder
var Cursor : CursorManager
var UIM : UIManager
var CooldownForActions = 0.3
var InitialWait = 1.6
var turnEnded = false
var LastSummonLength = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	BM = Globals.BoardManager
	Pathfind = Globals.Pathfinder
	Cursor = Globals.Cursor
	UIM = Globals.UIManager
	Globals.AIManager = self
	pass # Replace with function body.

func ProcessNextMove():
	##Move boss first
	var hand = Globals.CardManager.Hand2
	var curHand = []
	for x in hand:
		var C = CardBase.new()
		C.type = x.type
		C.number = x.number
		curHand.append(C)
	
	
	var summonTrack = GameManager.Player2Score[1]
	var summonPossible =  false
	var CardsYetToMove = false
	
	
	for x in curHand:
		if(summonTrack - x.number > 0):
			summonPossible = true
			
	var CardPieces = Globals.CardManager.PieceHolder.get_children()
	var PiecesToMove = []
	for x in CardPieces:
		if x.POwner != 1 and not x.waited:
			PiecesToMove.append(x)
			CardsYetToMove = true
		
	
	if(BM.P2LeaderPiece.waited == false):
		##Move cursor towards Piece
		var path = Pathfind.Pathfind(Cursor.curPos,BM.P2LeaderPiece.BPos)
		
		path.pop_at(0)
		print(path)
		
		var Action:AIAction = AIAction.new()
		Action.Action = "MoveCursor"
		Action.Data = path
		ActionQueue.append(Action)
		
		var Tiles = BM.GetPiecesWithinSpaces(BM.P2LeaderPiece.BPos,3)
		var closest = 99
		for x in Tiles:
			if BM.DistanceAway(x.BPos, BM.P2LeaderPiece.BPos)<closest and x.Piece.POwner == 1:
				closest = BM.DistanceAway(x.BPos, BM.P2LeaderPiece.BPos)
		if(closest > 3):
			var path2 = []
			path2.append("Confirm")
			
			var foo = Pathfind.Pathfind(BM.P2LeaderPiece.BPos, BM.P1LeaderPiece.BPos).slice(1,1)
			print(foo)
			path2.append(foo)
			path2.append("Confirm")
			print(path2)
			var Action2 : AIAction = AIAction.new()
			Action2.Action = "MovePiece"
			Action2.Data = path2
			ActionQueue.append(Action2)
		elif(closest == 3):
			var path2 = []
			path2.append("Confirm")
			path2.append("Confirm")
			print(path2)
			var Action2 : AIAction = AIAction.new()
			Action2.Action = "MovePiece"
			Action2.Data = path2
			ActionQueue.append(Action2)
		else:
			var path2 = []
			path2.append("Confirm")
			path2.append(Pathfind.Pathfind(BM.P2LeaderPiece.BPos, [0,0])[1])
			path2.append("Confirm")
			print(path2)
			var Action2 : AIAction = AIAction.new()
			Action2.Action = "MovePiece"
			Action2.Data = path2
			ActionQueue.append(Action2)
			
	##Summon something
	elif(UIM.hasSummoned == false and summonPossible):
		var choices = []
		var choice = null
		var curPos = BM.P2LeaderPiece.BPos
		for x in range(3):
			for y in range(3):
				var actualx = x-1 + curPos[0]
				var actualy = y-1 + curPos[1]
				if(actualx>6 or actualy >6 or actualx <0 or actualy <0):
					continue
				if(BM.Map[actualx][actualy].Piece==null):
					choices.append(BM.Map[actualx][actualy])
		var shortest = 99
		for x in choices:
			if(BM.DistanceAway(x.BPos, BM.P1LeaderPiece.BPos)<shortest):
				shortest = BM.DistanceAway(x.BPos, BM.P1LeaderPiece.BPos)
				choice = x.BPos
		
		var Act = AIAction.new()
		Act.Action= "Summon"
		var data = []
		data.append("Flip")
		data.append(choice)
		data.append("Confirm")
		
		var Act2 = AIAction.new()
		Act2.Action = "SummonUI"
		var data2 = []
		randomize()
		var fuseAmount = randi_range(0, len(curHand)-1)
		var fuseCardSlots = []
		for y in fuseAmount:
			var smallest = 99
			var smallSlot = -1
			for x in range(len(curHand)):
				if curHand[x].number<smallest:
					smallSlot = x 
					smallest = curHand[x].number
			fuseCardSlots.append(smallSlot)
			curHand[smallSlot].number = 99
		var LastChosen = 0
		LastSummonLength = len(fuseCardSlots)
		for x in Globals.CardManager.Hand2:
			print(x.number)
		for x in range(len(fuseCardSlots)):
			
			
			for l in range(abs(fuseCardSlots[x]-LastChosen)):
				if (LastChosen>fuseCardSlots[x]):
					data2.append("Left")
				else:
					data2.append("Right")
			data2.append("Flip")
			LastChosen = fuseCardSlots[x]
		data2.append("Confirm")
		data2.append("Confirm")
				
		##ChooseCards
		
		Act.Data = data 
		ActionQueue.append(Act)
		Act2.Data = data2
		ActionQueue.append(Act2)
		pass
	
	elif(CardsYetToMove):
		for x in PiecesToMove:
			var Action = AIAction.new()
			Action.Action = "MoveCursor"
			Action.Data = Pathfind.Pathfind(Cursor.curPos, x.BPos)
			Action.Data.pop_at(0)
			ActionQueue.append(Action)
			var Action2 = AIAction.new()
			Action.Action = "MoveCard"
			var Data2 = []
			Data2.append("Confirm")
			
			if(BM.isFavorableTerrain(BM.Map[x.BPos[0]][x.BPos[1]])):
				var pieces = BM.GetPiecesWithinSpaces(x.BPos, 2)
				var targets = []
				for y in pieces:
					if y.POwner!=GameManager.curPhase:
						targets.append(pieces)
				for y in targets:
					if (y.flipped == true and y.number+2<x.number) or (y.flipped == false):
						Data2.append("Flip")
						var path = Pathfind.Pathfind(x.BPos, y.BPos)
						path.pop_at(0)
						Data2.append(path)
						
						break
				Data2.append("Confirm")
			else:
				var pieces = BM.GetPiecesWithinSpaces(x.BPos, 1)
				var targets = []
				for y in pieces:
					if y.Piece.POwner!=GameManager.curPhase:
						targets.append(pieces)
				for y in targets:
					if (y.flipped == true and y.number+2<x.number) or (y.flipped == false):
						Data2.append("Flip")
						var path = Pathfind.Pathfind(x.BPos, y.BPos)
						path.pop_at(0)
						Data2.append(path)
						
						break
			Action2.Data = Data2
			ActionQueue.append(Action2)	
		pass
	
					
	else:##Append EndTurn
		var Act = AIAction.new()
		Act.Action = "EndTurn"
		ActionQueue.append(Act)
		pass
	if(turnEnded == false):
		ExecuteActions()
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(turnEnded == true):
		ActionQueue = []
		return
	if(GameManager.curPhase!=1):
		await get_tree().create_timer(InitialWait).timeout
		if(turnEnded == false and finishedActions == true):
			if(ActionQueue == []):
				ProcessNextMove()
		
		pass
	pass
var finishedActions = true
func ExecuteActions():
	finishedActions = false
	while(len(ActionQueue)>0):
		if(len(ActionQueue) == 0):
			return
		if(ActionQueue[0].Action == "MoveCursor"):
			
			for x in range(len(ActionQueue[0].Data)):
				if(len(ActionQueue[0].Data) == 0):
					
					break
				else:
					await get_tree().create_timer(CooldownForActions).timeout
					Cursor.MoveCursor(ActionQueue[0].Data[0])
					ActionQueue[0].Data.pop_at(0)
			ActionQueue.pop_at(0)
			pass
			
		
		elif(ActionQueue[0].Action == "MovePiece"):
			for x in range(len(ActionQueue[0].Data)):
				
				if(len(ActionQueue[0].Data) == 0):
					break
				else:
					await get_tree().create_timer(CooldownForActions).timeout
					
					if typeof(ActionQueue[0].Data[0])!= TYPE_STRING:
						Cursor.MoveCursor(ActionQueue[0].Data[0])
						ActionQueue[0].Data.pop_at(0)
					else:
						if(ActionQueue[0].Data[0] == "Confirm"):
							Cursor.Confirm()
							ActionQueue[0].Data.pop_at(0)
							pass
			pass
			ActionQueue.pop_at(0)
			pass
			
		elif(ActionQueue[0].Action == "MoveCard"):
			for x in range(len(ActionQueue[0].Data)):
				
				if(len(ActionQueue[0].Data) == 0):
					break
				else:
					await get_tree().create_timer(CooldownForActions).timeout
					
					if typeof(ActionQueue[0].Data[0])!= TYPE_STRING:
						Cursor.MoveCursor(ActionQueue[0].Data[0])
						ActionQueue[0].Data.pop_at(0)
					else:
						if(ActionQueue[0].Data[0] == "Confirm"):
							Cursor.Confirm()
							ActionQueue[0].Data.pop_at(0)
							pass
						if(ActionQueue[0].Data[0] == "Flip"):
							Cursor.Flip()
							ActionQueue[0].Data.pop_at(0)
							pass
			pass
			ActionQueue.pop_at(0)
			pass
		elif(ActionQueue[0].Action == "Summon"):
			for x in range(len(ActionQueue[0].Data)):
				if(len(ActionQueue[0].Data) == 0):
					break
				else:
					await get_tree().create_timer(CooldownForActions).timeout
					if typeof(ActionQueue[0].Data[0])!= TYPE_STRING:
						Cursor.MoveCursor(ActionQueue[0].Data[0])
						ActionQueue[0].Data.pop_at(0)
					else:
						if(ActionQueue[0].Data[0] == "Confirm"):
							Cursor.Confirm()
							ActionQueue[0].Data.pop_at(0)
							pass
						elif(ActionQueue[0].Data[0] == "Flip"):
							Cursor.Flip()
							ActionQueue[0].Data.pop_at(0)
							pass
			pass
			ActionQueue.pop_at(0)
			
		elif(ActionQueue[0].Action == "SummonUI"):
			for x in range(len(ActionQueue[0].Data)):
				if(len(ActionQueue[0].Data) == 0):
					break
				else:
					await get_tree().create_timer(CooldownForActions).timeout
					if typeof(ActionQueue[0].Data[0])!= TYPE_STRING:
						Cursor.MoveCursor(ActionQueue[0].Data[0])
						ActionQueue[0].Data.pop_at(0)
					else:
						if(ActionQueue[0].Data[0] == "Confirm"):
							UIM.PressConfirm()
							ActionQueue[0].Data.pop_at(0)
							pass
						elif(ActionQueue[0].Data[0] == "Flip"):
							UIM.PressFlip()
							ActionQueue[0].Data.pop_at(0)
							pass
						elif(ActionQueue[0].Data[0] == "Left"):
							UIM.PressLeft()
							ActionQueue[0].Data.pop_at(0)
							pass
						elif(ActionQueue[0].Data[0] == "Right"):
							UIM.PressRight()
							ActionQueue[0].Data.pop_at(0)
							pass
			pass
			ActionQueue.pop_at(0)	
			await get_tree().create_timer(1+LastSummonLength*0.5).timeout
		elif(ActionQueue[0].Action == "EndTurn"):
			
			GameManager.ChangeState("EndTurn")
			ActionQueue.pop_at(0)
			turnEnded = true
			finishedActions = true
	finishedActions = true
			
	pass
