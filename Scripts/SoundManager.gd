extends Node3D

class_name SoundManager

var SoundEffects = {
	"BattleOver": preload("res://Sounds/Sound Effects/BattleOver.wav"),
	"Cancel" : preload("res://Sounds/Sound Effects/Cancel.wav"),
	"CombatDone": preload("res://Sounds/Sound Effects/CombatDone.wav"),
	"CombatStart" : preload("res://Sounds/Sound Effects/CombatDone.wav"),
	"Confirm" : preload("res://Sounds/Sound Effects/Confirm.wav"),
	"CursorMove" : preload("res://Sounds/Sound Effects/CursorMove.wav"),
	"Fusion" : preload("res://Sounds/Sound Effects/Fusion.wav"),
	"PlaceCard" : preload("res://Sounds/Sound Effects/PlaceCard.wav"),
	"SummonCard" : preload("res://Sounds/Sound Effects/SummonCard.wav"),
	
}

var SoundEffectsVol = {
	"BattleOver": 50,
	"Cancel" : 50,
	"CombatDone":50,
	"CombatStart" :50,
	"Confirm" : 50,
	"CursorMove" : 30,
	"Fusion" :20,
	"PlaceCard" : 50,
	"SummonCard" : 50,
	
}
# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.SoundManager= self
	pass # Replace with function body
	
#func _process(delta):
#	if(Input.is_action_just_pressed("Test")):
#		PlaySoundEffect("CursorMove")

func PlaySoundEffect(which, volume=100, pitch = 1):
	var AudioObj = AudioStreamPlayer.new()
	add_child(AudioObj)
	AudioObj.stream = SoundEffects[which]
	AudioObj.volume_db = (volume-(200-SoundEffectsVol[which]))/4 
	AudioObj.play()
	await get_tree().process_frame
	await AudioObj.finished
	AudioObj.queue_free()
	
	pass
	
func PlayMusic(which, volume):
	
	pass
	
func FreeAudio():
	pass
