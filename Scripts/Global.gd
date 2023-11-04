extends Node

var score : int = 0
var lives : int = 3
var upgrade : int = 0
var level : int = 1
var difficulty : int = 0
var enemySpeedMultiplier : float = 1.0
var playerReference
var playerHealth
var camTargetReference
var bottomY : int = 220
var finishedLevel : bool = false

func _ready():
	if difficulty < 0:
		difficulty = 0
	if difficulty > 1:
		difficulty = 1
		
	match difficulty:
		0:
			# Normal difficulty.
			enemySpeedMultiplier = 1.0
			
		1:
			# Hard difficulty.
			enemySpeedMultiplier = 2.0

func delete_created_objects():
	for i in get_tree().root.get_child_count():
			if get_tree().root.get_children()[i].name != "global":
				get_tree().root.get_children()[i].queue_free()

func restart_scene():
	delete_created_objects()
	get_tree().reload_current_scene()

func go_to_level(number):
	level = number
	delete_created_objects()
	get_tree().change_scene_to_file("res://Scenes/Level" + str(number) + ".tscn")
	
func go_to_next_level():
	level += 1
	go_to_level(level)
	
func go_to_game_over():
	delete_created_objects()
	get_tree().change_scene_to_file("res://Scenes/GameOver.tscn")
	
func go_to_main_menu():
	delete_created_objects()
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
