extends Node2D

func _ready():
	$EditorReference.hide()

func _process(delta):
	if global.playerReference != null:
		if global.playerReference.global_position.x > global_position.x and global.hasCheckpoint == false and global.finishedLevel == false:
			global.hasCheckpoint = true
			global.checkpointPos = global_position
