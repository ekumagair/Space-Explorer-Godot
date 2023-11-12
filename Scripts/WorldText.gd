extends Label

@export var speed : float = 1

func _ready():
	await get_tree().create_timer(0.5).timeout
	queue_free()

func _process(delta):
	if position.y > 32:
		position.y -= speed * delta
