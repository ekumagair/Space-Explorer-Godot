extends Node

var score : int = 0
var highScore : int = 0
var lives : int = 3
var upgrade : int = 0
var level : int = 1
var difficulty : int = 0
var unlockedDifficulty : int = 0
var enemySpeedMultiplier : float = 1.0
var bottomY : int = 220
var finishedLevel : bool = false
var playerDied : bool = false
var hasCheckpoint : bool = false
var checkpointPos : Vector2
var masterVolume : int = 80

var playerReference
var playerHealth
var camTargetReference
var musicReference
var hudControlReference

const worldScorePath = preload('res://Prefabs/WorldScoreText.tscn')
const gameVersion = "1.0"
const maxLives = 99

func _ready():
	if difficulty < 0:
		difficulty = 0
	if difficulty > 1:
		difficulty = 1

func delete_created_objects():
	for i in get_tree().root.get_child_count():
			var nodeName : String = get_tree().root.get_children()[i].name
			if string_is_autoload_node(nodeName) == false:
				get_tree().root.get_children()[i].queue_free()

func restart_scene():
	playerDied = false
	get_tree().paused = false
	delete_created_objects()
	get_tree().reload_current_scene()

func go_to_level(number):
	playerDied = false
	finishedLevel = false
	level = number
	save_high_score()
	delete_created_objects()
	get_tree().change_scene_to_file("res://Scenes/Level" + str(number) + ".tscn")
	
func go_to_next_level():
	level += 1
	hasCheckpoint = false
	go_to_level(level)
	
func go_to_game_over():
	hasCheckpoint = false
	save_high_score()
	delete_created_objects()
	get_tree().change_scene_to_file("res://Scenes/GameOver.tscn")
	
func go_to_main_menu():
	hasCheckpoint = false
	save_high_score()
	reset_variables()
	delete_created_objects()
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")

func win_game(delay):
	get_tree().paused = false
	save_high_score()
	
	await get_tree().create_timer(5 if delay else 0).timeout
	
	delete_created_objects()
	get_tree().change_scene_to_file("res://Scenes/Victory.tscn")
	
func save_high_score():
	if score > highScore:
		highScore = score
		
	savedata.save_game()

func reset_variables():
	score = 0
	lives = 3
	upgrade = 0
	level = 1
	
func create_score_text(origin : Node2D, message : String):
	var obj = worldScorePath.instantiate()
	get_tree().root.add_child(obj)

	obj.position = origin.global_position
	obj.text = message
	
func create_extra_life_text(origin : Node2D):
	var obj = worldScorePath.instantiate()
	get_tree().root.add_child(obj)

	obj.position = origin.global_position - Vector2(0, 12)
	obj.text = "1-UP"
	obj.modulate = Color(0, 1, 0)

func current_time():
	return str(Time.get_date_dict_from_system().year) + "-" + str(Time.get_date_dict_from_system().month) + "-" + str(Time.get_date_dict_from_system().day) + " " + str(Time.get_time_dict_from_system().hour) + "-" + str(Time.get_time_dict_from_system().minute) + "-" + str(Time.get_time_dict_from_system().second)

func string_is_autoload_node(text : String):
	return text == "global" or text == "savedata" or text == "screenshot"
