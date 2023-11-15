extends Node

@onready var sound = $Sound

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event):
	if event.is_action_pressed("Pause") and global.finishedLevel == false and global.playerDied == false:
		sound.play()
		get_tree().paused = !get_tree().paused
	elif event.is_action_pressed("ui_cancel") and get_tree().paused == true:
		global.go_to_main_menu()
