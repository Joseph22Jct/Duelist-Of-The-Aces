extends Node3D

var Started = false
var curSelect = 0
var maxChoices = 2
var menu = 0
var menuObjects = []
var GameObject = preload("res://Objects/MainScene.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	menuObjects = $MenuOptions.get_children()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(not Started):
		return
	if (Input.is_action_just_pressed("Left") or Input.is_action_just_pressed("Up") ):
		StepBack()
	if (Input.is_action_just_pressed("Right")or Input.is_action_just_pressed("Down")):
		StepForward()
	if(Input.is_action_just_pressed("Confirm") and Started):
		Confirm()
	if(Input.is_action_just_pressed("Cancel")):
		Cancel()
		
	pass

func StepBack():
	curSelect-=1
	if(curSelect <= -1):
		curSelect = maxChoices-1
	if(menu == 0):
		
		await get_tree().process_frame
		$MenuOptions/Selection.position= menuObjects[curSelect].position - Vector2(50,0)
		pass
	elif(menu == 1):
		
		await get_tree().process_frame
		$FightCPUOptions/Selection.position= menuObjects[curSelect].position - Vector2(50,0)
		pass
	
	pass

func StepForward():
	curSelect+=1
	if(curSelect >= maxChoices):
		curSelect = 0
	
	if(menu == 0):
		await get_tree().process_frame
		var newPos = menuObjects[curSelect].position - Vector2(50,0)
		$MenuOptions/Selection.position = newPos
	elif(menu == 1):
		
		await get_tree().process_frame
		$FightCPUOptions/Selection.position= menuObjects[curSelect].position - Vector2(50,0)
		pass
	
	pass
func Confirm():
	if(menu == 0):
		if(curSelect == 0):
			menu =1 
			maxChoices = 6
			menuObjects = $FightCPUOptions.get_children()
			$FightCPUOptions.visible = true
			$MenuOptions.visible = false 
			curSelect == 0
			pass
		else:
			menu = 2
			maxChoices = 1
			$MenuOptions.visible = false 
			$Tutorial.visible = true
		pass
	elif(menu ==1):
		Globals.SoundManager.PlaySoundEffect("CombatStart")
		GameManager.SelectedBoard = curSelect
		var GO = GameObject.instantiate()
		GameManager.add_child(GO)
		GameManager.GameplayObject = GO
		await get_tree().process_frame
		GameManager.ChangeState("Main")
		
		queue_free()
		##StartGame
		pass
	pass

func Cancel():
	if(menu==0):
		Globals.SoundManager.PlaySoundEffect("Cancel")
		Started = false
		$MenuOptions.visible = false
		$PressAnyButtonText.visible = true
	elif(menu == 1):
		Globals.SoundManager.PlaySoundEffect("Cancel")
		menu =0
		maxChoices = 2
		menuObjects = $MenuOptions.get_children()
		$FightCPUOptions.visible = false
		$MenuOptions.visible = true
		pass
	elif (menu == 2):
		menu = 0
		maxChoices = 2
		$MenuOptions.visible = true
		$Tutorial.visible = false

func _unhandled_key_input(event):
	if event.is_pressed():
		if(not Started):
			await get_tree().process_frame
			Globals.SoundManager.PlaySoundEffect("CombatStart")
			Started = true
			$PressAnyButtonText.visible = false
			print("Works")
			$MenuOptions.visible = true
			
