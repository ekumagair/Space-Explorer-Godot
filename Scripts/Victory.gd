extends Node
	
func _ready():
	global.reset_variables()
	
	if global.unlockedDifficulty == 0:
		global.unlockedDifficulty = 1
		global.difficulty = 1
		$UnlockText.show()
	else:
		$UnlockText.hide()
		
	savedata.save_game()
	
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		end()
		
func end():
	print("difficulty = " + str(global.difficulty))
	global.go_to_main_menu()
