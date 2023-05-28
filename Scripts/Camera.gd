extends Node3D

var POffset = Vector3(0,6,6.5)
var curPhaseCam = 1
var currentP = [3,3]
var ROffset = Vector3(0,180,0)
# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.Camera = self
	await get_tree().process_frame
	Globals.Cursor.connect("CursorMoved", Callable(self, "FollowCursor"))
	pass # Replace with function body.

func FollowCursor(oldPos, curPos, time = 0.5):
	currentP = curPos
	var tween = get_tree().create_tween()
	var newPos
	if(curPhaseCam == 1):
		newPos = Vector3(2*(curPos[0]-3),0,2*(curPos[1]-3))
	else:
		newPos = Vector3(2*(curPos[0]-3)*-1,0,2*(curPos[1]-3)*-1)
	tween.tween_property($Camera, "position", POffset+newPos , time)
	

var CurRot 
func CameraShift(curPhase):
	curPhaseCam = curPhase
	var tween = get_tree().create_tween()
	CurRot = Vector3(0,180*(curPhase-1),0)
	FollowCursor([], currentP , 1.5)
	tween.tween_property(self, "rotation_degrees", CurRot, 1.5)
	
	tween.tween_callback(OnCallback)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func OnCallback():
	
	GameManager.ChangeState("Main")
