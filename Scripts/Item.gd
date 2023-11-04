extends Area2D

@export var animation = "yellow"
@export var giveScore : int = 0
@export var giveWeapon : int = -1
@export var giveHealth : int = 0

@onready var sprite = $AnimatedSprite2D
@onready var soundCollect = $SoundCollect

func _ready():
	if animation != "":
		sprite.play(animation)

func _on_body_entered(body):
	if body.name == "Player":
		queue_free()
		global.score += giveScore
		
		if giveHealth > 0 and body.get_node("HealthComponent").health >= 3:
			global.lives += 1
			
		body.get_node("HealthComponent").change_health(giveHealth)
		
		if giveWeapon >= 0:
			global.upgrade = giveWeapon
			
		if soundCollect != null:
			soundCollect.reparent(get_tree().root, true)
			soundCollect.play()
