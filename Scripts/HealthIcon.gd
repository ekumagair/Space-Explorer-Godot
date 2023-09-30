extends TextureRect

@export var minimum : int = 0

func _process(delta):
	if global.playerHealth != null:
		if minimum > global.playerHealth.health:
			self.hide()
		else:
			self.show()
