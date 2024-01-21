extends Node

var identifier : int = 0

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	identifier = 0
	identifier_reset()

func _process(delta):
	if Input.is_action_just_pressed("Screenshot"):
		take_screenshot()

func take_screenshot():
	var img = get_viewport().get_texture().get_image()
	
	if DirAccess.dir_exists_absolute("user://screenshots") == false:
		DirAccess.make_dir_absolute("user://screenshots")
	
	img.save_png("user://screenshots/SpaceExplorer " + global.current_time() + " " + str(identifier) + ".png")
	identifier += 1

func identifier_reset():
	await get_tree().create_timer(1).timeout
	identifier = 0
	identifier_reset()
