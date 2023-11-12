extends Node

func save_game():
	var file : FileAccess = FileAccess.open("user://playerdata.save", FileAccess.WRITE)
	
	var data : Dictionary = {
		highScore = global.highScore,
		masterVolume = global.masterVolume,
		currentDifficulty = global.difficulty,
		unlockedDifficulty = global.unlockedDifficulty
	}
	
	file.store_string(JSON.stringify(data))
	file.close()

func load_game():
	var data : Dictionary = get_stored_data()
	
	if data.is_empty():
		return
	
	global.highScore = data.get("highScore", 0)
	global.masterVolume = data.get("masterVolume", 80)
	global.difficulty = data.get("currentDifficulty", 0)
	global.unlockedDifficulty = data.get("unlockedDifficulty", 0)
	
func get_stored_data():
	var fileName : String = "user://playerdata.save"
	
	if FileAccess.file_exists(fileName):
		var file : FileAccess = FileAccess.open("user://playerdata.save", FileAccess.READ)
		var data : Dictionary = JSON.parse_string(file.get_as_text())
		file.close()
		
		return data
	else:
		return {}
