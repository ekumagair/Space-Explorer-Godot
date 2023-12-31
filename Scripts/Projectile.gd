extends Area2D

@export var direction = Vector2(-1, 0)
@export var speed : float = 400
@export var damage : int = 1
@export var perforation : int = 1
@export var deleteOffScreen : bool = true
@export var isFromEnemy : bool = false

var destroyed : bool = false

func _process(delta):
	global_position += direction.normalized() * delta * speed * (global.enemySpeedMultiplier if isFromEnemy else 1.0)
	
	if deleteOffScreen == true:
		delete_off_screen()

func _on_body_entered(body):
	if body.has_node("HealthComponent") and destroyed == false:
		if body.get_node("HealthComponent").invulnerable == false:
			perforation -= 1
			if perforation <= 0:
				destroyed = true
				queue_free()
		
			body.get_node("HealthComponent").change_health(-damage)

func delete_off_screen():
	if $VisibleOnScreenNotifier2D.is_on_screen() == false:
		queue_free()
