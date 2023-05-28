extends Node3D

signal CursorMoved(oldspot, newSpot)
var curPos = [3,3]
var oldPos = [3,3]
var CM : CardManager
var enabledCursor = true 
var curTileSelectedMov = null
var curflippedStatus = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.Cursor = self
	await get_tree().process_frame
	MoveCursor(curPos)
	CM = Globals.CardManager
	pass # Replace with function body.
	
func GetCurBoardTile():
	return Globals.BoardManager.Map[curPos[0]][curPos[1]]

func CancelMov():
	if(curTileSelectedMov.Piece!=null):
		if(curTileSelectedMov.Piece.flipped != curflippedStatus):
			curTileSelectedMov.Piece.flipped = curflippedStatus
			curTileSelectedMov.Piece.flipCard()
		if(curTileSelectedMov.Piece.CardObj!=null):
			curTileSelectedMov.Piece.CardObj.position = Vector3.ZERO
	MoveCursor(curTileSelectedMov.BPos)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$CursorBlend.rotate_y(delta)
	if(not enabledCursor):
		return
	
		
	if(Input.is_action_just_pressed("Up")):
		if(curPos[1]>0):
			if(Globals.GameManager.cState == "MovePiece" ):
				if(not Globals.BoardManager.Map[curPos[0]][curPos[1]-1].Actionable):
					return
			MoveCursor([curPos[0], curPos[1]-1])
	if(Input.is_action_just_pressed("Down")):
		if(curPos[1]<6):
			if(Globals.GameManager.cState == "MovePiece" ):
				if(not Globals.BoardManager.Map[curPos[0]][curPos[1]+1].Actionable):
					return
			MoveCursor([curPos[0], curPos[1]+1])
			
	if(Input.is_action_just_pressed("Left")):
		if(curPos[0]>0):
			if(Globals.GameManager.cState == "MovePiece" ):
				if(not Globals.BoardManager.Map[curPos[0]-1][curPos[1]].Actionable):
					return
			MoveCursor([curPos[0]-1, curPos[1]])
	if(Input.is_action_just_pressed("Right")):
		if(curPos[0]<6):
			if(Globals.GameManager.cState == "MovePiece" ):
				if(not Globals.BoardManager.Map[curPos[0]+1][curPos[1]].Actionable):
					return
			MoveCursor([curPos[0]+1, curPos[1]])
	
	if(Input.is_action_just_pressed("SummonFlip")):
		if(Globals.GameManager.cState == "Main" and Globals.BoardManager.P1LeaderPiece.BPos == curPos):
			if(len(Globals.CardManager.Hand1) >0):
				Globals.GameManager.ChangeState("Summon")
				Globals.SoundManager.PlaySoundEffect("Confirm")
		pass
	
	if(Input.is_action_just_released("Confirm")):
		if(Globals.GameManager.cState == "Main"):
			var Piece = Globals.BoardManager.Map[curPos[0]][curPos[1]].Piece
			if(Piece!=null and Piece.POwner ==GameManager.curPhase and Piece.waited!=true):
				curTileSelectedMov = GetCurBoardTile()
				curflippedStatus = Piece.flipped
				Globals.GameManager.ChangeState("MovePiece")
				Globals.SoundManager.PlaySoundEffect("Confirm")
				pass
		
			
		elif(Globals.GameManager.cState == "Summon" ):
			print(curPos)
			print(Globals.BoardManager.Map[curPos[0]][curPos[1]].Actionable)
			if(Globals.BoardManager.Map[curPos[0]][curPos[1]].Actionable == true):
				print("Workds")
				Globals.GameManager.ChangeState("ShowCards")
				Globals.SoundManager.PlaySoundEffect("Confirm")
				
		elif(Globals.GameManager.cState == "MovePiece" ):
			
			
			if(Globals.BoardManager.Map[curPos[0]][curPos[1]].Actionable == true):
				if(GetCurBoardTile().Piece !=null):
					if(GetCurBoardTile().Piece.type == 0 and GetCurBoardTile().Piece.POwner == GameManager.curPhase):
						Globals.SoundManager.PlaySoundEffect("Cannot")
						return
					else:
						var enemyTile: BoardTile = GetCurBoardTile()
						if(enemyTile.Piece.POwner != GameManager.curPhase):
							Globals.GameManager.ChangeState("Combat")
							Globals.BoardManager.MovePiece(curTileSelectedMov, oldPos)
							Globals.CombatManager.InitiatingTile = Globals.BoardManager.Map[oldPos[0]][oldPos[1]]
							Globals.CombatManager.StartCombat(Globals.CombatManager.InitiatingTile.Piece,enemyTile.Piece, enemyTile)
							pass
						return
						
				print("Workds")
				Globals.BoardManager.MovePiece(curTileSelectedMov, curPos)
				Globals.GameManager.ChangeState("Main")
				Globals.SoundManager.PlaySoundEffect("Confirm")
				
				
	
	
	if(Input.is_action_just_released("SummonFlip")):
		var tileToCheck = curTileSelectedMov
		if(Globals.GameManager.cState == "MovePiece" and curPos == tileToCheck.BPos and not curflippedStatus):
			tileToCheck.Piece.flipped = not tileToCheck.Piece.flipped
			tileToCheck.Piece.flipCard()
			Globals.BoardManager.ShowTraversibleTiles()
			pass
		pass
			
#	if(Input.is_action_just_released("Test")):
#		print(Globals.Pathfinder.Pathfind(curPos.duplicate(), [3,3]))
#		var Card = CM.SpawnCard(null, randi_range(0,4), randi_range(1,13))
#		add_child(Card)
#		Card.global_position = Vector3(0,4,0)
#		Card.rotation_degrees = Vector3(0,0,180)
			
	pass
	
func MoveCursor(newPos):
	Globals.SoundManager.PlaySoundEffect("CursorMove")
	oldPos = curPos
	curPos = newPos
	emit_signal("CursorMoved", oldPos, curPos)
	var tween = get_tree().create_tween()
	var nPos = Vector3(2*(curPos[0]-3),position.y,2*(curPos[1]-3))
	tween.tween_property(self, "position", nPos , 0.2).set_trans(Tween.TRANS_CUBIC)
	print("Cursor moved to:" +str(curPos) + " with BoardPos: "+ str(Globals.BoardManager.Map[curPos[0]][curPos[1]].BPos))
	
	if(GameManager.cState == "MovePiece"):
		var piece:CardPiece = curTileSelectedMov.Piece
		if(piece.type == 0):
			tween = get_tree().create_tween()
			var tileTo = Globals.BoardManager.Map[curPos[0]][curPos[1]].global_position
			newPos = Vector3(tileTo.x, piece.global_position.y, tileTo.z)
			tween.tween_property(piece, "global_position", newPos , 0.2).set_trans(Tween.TRANS_LINEAR)
			##Move the entire object
			pass
		else:
			tween = get_tree().create_tween()
			var tileTo = Globals.BoardManager.Map[curPos[0]][curPos[1]].global_position
			newPos = Vector3(tileTo.x, piece.global_position.y, tileTo.z)
			tween.tween_property(piece.CardObj, "global_position", newPos , 0.2).set_trans(Tween.TRANS_LINEAR)
			
			pass
	
func ToggleCursor(boolean):
	enabledCursor = boolean
	
