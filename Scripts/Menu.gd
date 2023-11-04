extends Control

@export var defaultButton : Button
@export var cursorRect : TextureRect

enum MENU_BUTTON_ACTION { START_GAME, QUIT }

func _ready():
	if defaultButton != null:
		defaultButton.grab_focus()

func _process(delta):
	if get_viewport().gui_get_focus_owner() != null:
		cursorRect.global_position.y = get_viewport().gui_get_focus_owner().global_position.y + 10

func _on_button_play_pressed():
	cursor_animation(MENU_BUTTON_ACTION.START_GAME, true)
	$VBoxContainer/ButtonPlay/SoundPress.play()

func _on_button_quit_pressed():
	cursor_animation(MENU_BUTTON_ACTION.QUIT, true)
	$VBoxContainer/ButtonQuit/SoundPress.play()

func cursor_animation(action : MENU_BUTTON_ACTION, flashCursor : bool):
	get_viewport().gui_get_focus_owner().release_focus()
	cursorRect.show()
	
	if flashCursor == true:
		for i in 6:
			cursorRect.hide()
			await get_tree().create_timer(0.1).timeout
			cursorRect.show()
			await get_tree().create_timer(0.1).timeout
		
	if action == MENU_BUTTON_ACTION.START_GAME:
		#get_tree().change_scene_to_file("res://Scenes/TestScene.tscn")
		global.go_to_level(1)
	elif action == MENU_BUTTON_ACTION.QUIT:
		get_tree().quit()
