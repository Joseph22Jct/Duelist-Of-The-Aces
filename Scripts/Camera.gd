extends Camera3D

var POffset = Vector3(0,6,6.5)
var ROffset = Vector3(-30,0,0)
# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.Camera = self
	await get_tree().process_frame
	Globals.Cursor.connect("CursorMoved", Callable(self, "FollowCursor"))
	pass # Replace with function body.

func FollowCursor(oldPos, curPos):
	var tween = get_tree().create_tween()
	var newPos = Vector3(2*(curPos[0]-3),0,2*(curPos[1]-3))
	tween.tween_property(self, "position", POffset+newPos , 0.5)
	
	tween.tween_callback(OnCallback)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func OnCallback():
	print("Followed Cursor! To: "+ str(Globals.Cursor.curPos))
