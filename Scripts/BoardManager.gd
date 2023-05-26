extends Node3D

var Map = []
var BoardTiles = preload("res://Objects/board_tile.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.BoardManager = self
	for y in range(7):
		Map.append([])
		for x in range(7):
			var BT= BoardTiles.instantiate()
			$Tiles.add_child(BT)
			BT.position = Vector3((y-3)*2,0.6,(x-3)*2)
			Map[y-1].append(BT)
			BT.BPos = [x,y]
			BT.SetType(x)
			
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
