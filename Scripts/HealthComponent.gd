extends Node2D

@export var health : int = 3
@export var invulnerable : bool = false
@export var afterHitBlinkTime : int = 0
@export var pointsOnDeath : int = 0

@onready var soundHurt = $SoundHurt
@onready var soundDeath = $SoundDeath

var parent
var fellInPit : bool = false
var startHealth : int = 3

func _ready():
	parent = get_parent()
	fellInPit = false
	startHealth = health

func _process(delta):
	if global_position.y > global.bottomY:
		fellInPit = true
		health = 0
		
	if health <= 0:
		soundDeath.reparent(get_tree().root, true)
		soundDeath.play()
		
		if fellInPit == false:
			global.score += pointsOnDeath
		
		parent.queue_free()

func change_health(amount):
	if invulnerable == false or amount > 0:
		health += amount
		
		if amount < 0 and afterHitBlinkTime > 0 and health > 0:
			after_hit_blink()
			soundHurt.play()
			
		if get_parent().has_method("on_change_health"):
			get_parent().on_change_health(amount)
			
		if health < 0:
			health = 0
			
		if health > startHealth:
			health = startHealth

func after_hit_blink():
	invulnerable = true
	
	for i in afterHitBlinkTime:
		parent.hide()
		await get_tree().create_timer(0.1).timeout
		parent.show()
		await get_tree().create_timer(0.1).timeout
	
	parent.show()
	invulnerable = false
