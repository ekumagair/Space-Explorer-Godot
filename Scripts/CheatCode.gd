extends Node

enum Cheat {LIVES, UPGRADE, CONTINUE}

@export var cheatType : Cheat
@export var useLimit : int = 1
@export var code : Array[InputEventKey]

var keyIndex : int = 0
var uses : int = 0

func _input(event):
	if uses >= useLimit or len(code) < 1:
		return
	
	if event is InputEventKey and event.pressed:
		if event.keycode == code[keyIndex].keycode:
			keyIndex += 1
			#print(str(keyIndex) + "/" + str(len(code)))
		else:
			keyIndex = 0
			
	if keyIndex >= len(code):
		#print("Cheat successful!")
		keyIndex = 0
		uses += 1
		
		match cheatType:
			Cheat.LIVES:
				global.lives = 30
			Cheat.UPGRADE:
				global.upgrade = 1
			Cheat.CONTINUE:
				global.score = 0
				global.lives = 3
				global.upgrade = 0
				global.hasCheckpoint = false
				global.go_to_level(global.level)
