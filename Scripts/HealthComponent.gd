extends Node2D

@export var health : int = 3
@export var invulnerable : bool = false
@export var afterHitBlinkTime : int = 0
@export var pointsOnDeath : int = 0
@export var alwaysPlayDeathSound : bool = false
@export var isPlayer : bool = false
@export var createOnDeath : Array[PackedScene]

@onready var soundHurt = $SoundHurt
@onready var soundDeath = $SoundDeath

var parent
var fellInPit : bool = false
var died : bool = false
var startHealth : int = 3

func _ready():
	parent = get_parent()
	fellInPit = false
	died = false
	startHealth = health

func _process(delta):
	if global_position.y > global.bottomY:
		fellInPit = true
		health = 0
		
	if health <= 0:
		die()

func change_health(amount):
	if invulnerable == false or amount > 0:
		health += amount
		
		if amount < 0 and health > 0:
			if afterHitBlinkTime > 0:
				after_hit_blink()
				
			soundHurt.play()
			
		if parent.has_method("on_change_health"):
			parent.on_change_health(amount)
			
		if health < 0:
			health = 0
			
		if health > startHealth:
			health = startHealth

func after_hit_blink():
	invulnerable = true
	
	for i in afterHitBlinkTime:
		if health <= 0 or is_instance_valid(self) == false:
			return
		parent.hide()
		await get_tree().create_timer(0.1).timeout
		
		if health <= 0 or is_instance_valid(self) == false:
			return
		parent.show()
		await get_tree().create_timer(0.1).timeout
	
	parent.show()
	invulnerable = false

func die():
	if died == true:
		return
	
	health = 0
	died = true
	
	if fellInPit == false:
		global.score += pointsOnDeath
		
		if pointsOnDeath != 0 and isPlayer == false:
			global.create_score_text(self, str(pointsOnDeath))
			
	if fellInPit == false or alwaysPlayDeathSound == true:
		soundDeath.reparent(get_tree().root, true)
		soundDeath.play()
	
	if createOnDeath != null:
		for i in createOnDeath.size():
			var created = createOnDeath[i].instantiate()
			get_tree().root.add_child(created)
			created.global_transform = self.global_transform
	
	if isPlayer == true:
		reparent(get_tree().root, true)
		player_death()
		
	if parent.has_method("on_death"):
		parent.on_death()
	
	parent.queue_free()

func player_death():
	global.save_high_score()
	
	await get_tree().create_timer(3).timeout
	
	global.upgrade = 0
	global.lives -= 1
	
	if global.lives > 0:
		global.restart_scene()
	else:
		global.go_to_game_over()
