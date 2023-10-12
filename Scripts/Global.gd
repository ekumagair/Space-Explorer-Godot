extends Node

var score : int = 0
var lives : int = 3
var level : int = 1
var playerReference
var playerHealth
var bottomY : int = 220

func delete_created_objects():
	for i in get_tree().root.get_child_count():
			if get_tree().root.get_children()[i].name != "global":
				get_tree().root.get_children()[i].queue_free()

func restart_scene():
	delete_created_objects()
	get_tree().reload_current_scene()
