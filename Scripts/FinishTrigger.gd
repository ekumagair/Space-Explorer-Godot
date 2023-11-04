extends Area2D

func _process(delta):
	if global.playerReference != null:
		if global_position.x < global.playerReference.global_position.x:
			global.camTargetReference.blockScrollAll = true

func _on_body_entered(body):
	if body.name == "Player" and global.finishedLevel == false:
		body.on_finish_level()
		on_finish_level()

func on_finish_level():
	global.finishedLevel = true
	$AnimatedSprite2D.play("active")
	
	await get_tree().create_timer(3).timeout
	
	global.go_to_next_level()
