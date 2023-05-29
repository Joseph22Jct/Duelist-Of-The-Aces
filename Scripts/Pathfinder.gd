extends Node3D
class_name Pathfinder

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.Pathfinder = self
	pass # Replace with function body.



func Pathfind(start, finish):
	if(start == finish):
		return []
	var cur = start ##[0,0]
	var path = [cur.duplicate()]
	var xAdd = sign(finish[0] - start[0])
	var yAdd = sign(finish[1]- start[1])

	while cur!=finish:
		#print(str(cur)+ " with finish: " + str(finish))
		if(cur[0]!= finish[0] and cur[1]!=finish[1]):
			randomize()
			if(randi_range(0,1) == 0):
				cur[0]+=xAdd
			else:
				cur[1]+=yAdd
		elif(cur[0]!=finish[0]):
			cur[0]+=xAdd
		elif(cur[1]!= finish[1]):
			cur[1]+=yAdd
		
		
		
		path.append(cur.duplicate())
		
	return path
	
	
