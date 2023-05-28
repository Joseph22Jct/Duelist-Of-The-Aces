extends Node3D

signal CursorMoved(oldspot, newSpot)
var curPos = [3,3]
var oldPos = [3,3]
var CM : CardManager
var enabledCursor = true 

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.Cursor = self
	await get_tree().process_frame
	MoveCursor(curPos)
	CM = Globals.CardManager
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$CursorBlend.rotate_y(delta)
	if(not enabledCursor):
		return
		
	if(Input.is_action_just_pressed("Up")):
		if(curPos[1]>0):
			MoveCursor([curPos[0], curPos[1]-1])
	if(Input.is_action_just_pressed("Down")):
		if(curPos[1]<6):
			MoveCursor([curPos[0], curPos[1]+1])
			
	if(Input.is_action_just_pressed("Left")):
		if(curPos[0]>0):
			MoveCursor([curPos[0]-1, curPos[1]])
	if(Input.is_action_just_pressed("Right")):
		if(curPos[0]<6):
			MoveCursor([curPos[0]+1, curPos[1]])
	
	if(Input.is_action_just_pressed("SummonFlip")):
		if(Globals.GameManager.cState == "Main" and Globals.BoardManager.P1LeaderPiece.BPos == curPos):
			if(len(Globals.CardManager.Hand1) >0):
				Globals.GameManager.ChangeState("Summon")
				Globals.SoundManager.PlaySoundEffect("Confirm")
		pass
	
	if(Input.is_action_just_released("Confirm")):
		if(Globals.GameManager.cState == "Summon" ):
			print(curPos)
			print(Globals.BoardManager.Map[curPos[0]][curPos[1]].Actionable)
			if(Globals.BoardManager.Map[curPos[0]][curPos[1]].Actionable == true):
				print("Workds")
				Globals.GameManager.ChangeState("ShowCards")
				Globals.SoundManager.PlaySoundEffect("Confirm")
		pass
			
#	if(Input.is_action_just_released("Test")):
#		print(Globals.Pathfinder.Pathfind(curPos.duplicate(), [3,3]))
#		var Card = CM.SpawnCard(null, randi_range(0,4), randi_range(1,13))
#		add_child(Card)
#		Card.position = Vector3(0,4,0)
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
	
func ToggleCursor(boolean):
	enabledCursor = boolean
	
