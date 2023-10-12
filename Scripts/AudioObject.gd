extends AudioStreamPlayer

@export var destroyOnFinish : bool = true

func _on_finished():
	if destroyOnFinish == true:
		queue_free()
