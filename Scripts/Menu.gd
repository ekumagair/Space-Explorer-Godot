extends Control

@export var cursorRect : TextureRect
@export var contentPages : Array[Node]
@export var defaultButton : Array[Button]
@export var optionVolume : GameOptionButton
@export var optionDifficulty : GameOptionButton

enum MENU_BUTTON_ACTION { START_GAME, OPTIONS, CONTROLS, QUIT }

var timeSinceReady : float = 0
var deleteTimer : float = 0
var selectAnim : bool = false

func _ready():
	get_tree().paused = false
	savedata.load_game()
	$HighScoreValue.text = str(global.highScore)
	
	optionDifficulty.value = global.difficulty
	timeSinceReady = 0
	selectAnim = false
	global.playerDied = false
	global.finishedLevel = false
	
	if optionVolume != null:
		optionVolume.value = global.masterVolume
	
	go_to_page(0)

func _process(delta):
	if get_viewport().gui_get_focus_owner() != null:
		cursorRect.global_position.y = get_viewport().gui_get_focus_owner().global_position.y + 10
		
	if timeSinceReady < 2000000000.0:
		timeSinceReady += delta
	
	# Volume
	if optionVolume != null:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(float(global.masterVolume) / 100.0))
		optionVolume.set_value_text()
		global.masterVolume = optionVolume.value
	
	# Difficulty
	if optionDifficulty != null:
		global.difficulty = optionDifficulty.value
		optionDifficulty.set_value_text()
	
	# Delete
	if Input.is_action_pressed("ui_text_delete") and selectAnim == false and timeSinceReady > 2:
		deleteTimer += delta
		
		if deleteTimer > 3:
			global.difficulty = 0
			global.unlockedDifficulty = 0
			global.level = 1
			global.score = 0
			global.highScore = 0
			optionDifficulty.value = 0
			
			savedata.save_game()
			deleteTimer = 0
			
			$HighScoreValue.text = str(global.highScore)
			$DeleteSound.play()
	else:
		deleteTimer = 0
		
	# Quit game
	if Input.is_action_just_pressed("ui_cancel") and timeSinceReady > 1:
		get_tree().quit()

func _on_button_play_pressed():
	cursor_animation(MENU_BUTTON_ACTION.START_GAME, true)
	$MainSelection/ButtonPlay/SoundPress.play()
	
func _on_button_options_pressed():
	$MainSelection/ButtonOptions/SoundPress.play()
	go_to_page(1)
	
func _on_button_controls_pressed():
	$MainSelection/ButtonControls/SoundPress.play()
	go_to_page(2)

func _on_button_quit_pressed():
	cursor_animation(MENU_BUTTON_ACTION.QUIT, true)
	$MainSelection/ButtonQuit/SoundPress.play()
	
func _on_button_options_back():
	go_to_page(0)
	$Options/ButtonBack/SoundPress.play()

func cursor_animation(action : MENU_BUTTON_ACTION, flashCursor : bool):
	get_viewport().gui_get_focus_owner().release_focus()
	selectAnim = true
	cursorRect.show()
	
	if flashCursor == true:
		for i in 6:
			cursorRect.hide()
			await get_tree().create_timer(0.1).timeout
			cursorRect.show()
			await get_tree().create_timer(0.1).timeout
			
	selectAnim = false
	
	if action == MENU_BUTTON_ACTION.START_GAME:
		#get_tree().change_scene_to_file("res://Scenes/TestScene.tscn")
		global.go_to_level(1)
	elif action == MENU_BUTTON_ACTION.QUIT:
		get_tree().quit()

func go_to_page(number : int):
	for i in contentPages.size():
		if i != number:
			contentPages[i].hide()
		else:
			contentPages[i].show()
		
	defaultButton[number].grab_focus()
