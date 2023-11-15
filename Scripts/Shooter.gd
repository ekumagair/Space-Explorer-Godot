extends Node

@export var waitUntilOnScreen : bool = true
@export var affectedBySpeedMultiplier : bool = true
@export var shotPath : PackedScene
@export var direction : Vector2
@export var shotDelay : float = 2.0
@export var shotDelayRandomize : bool = true
@export var spawnOffset : Vector2
@export var onlyFireOnScreen : bool = true

@onready var soundFire = $SoundFire

var active : bool = false
var allowShot : bool = true
var startedLoop : bool = false
var rng = RandomNumberGenerator.new()
var visibilityNotifier = null
var healthComponent = null
var walkComponent = null

func _ready():
	active = false
	startedLoop = false
	if get_parent().has_node("VisibleOnScreenNotifier2D"):
		visibilityNotifier = get_parent().get_node("VisibleOnScreenNotifier2D")
	if get_parent().has_node("HealthComponent"):
		healthComponent = get_parent().get_node("HealthComponent")

func _process(delta):
	if waitUntilOnScreen == true:
		if visibilityNotifier.is_on_screen():
			active = true
	else:
		active = true
		
	if active == true and startedLoop == false and visibilityNotifier.is_on_screen():
		startedLoop = true
		shoot_loop()

func shoot_loop():
	# Create the projectile.
	if (visibilityNotifier.is_on_screen() or onlyFireOnScreen == false) and allowShot == true and get_tree().paused == false:
		var projectile = shotPath.instantiate()
		
		if direction == Vector2.ZERO:
			projectile.direction.x = get_parent().direction
		else:
			projectile.direction = direction
			
		get_tree().root.add_child(projectile)
		projectile.global_transform = self.global_transform
		projectile.position.y += spawnOffset.y
		
		# Play firing sound.
		soundFire.play()
		
		# Call shoot method.
		if get_parent().has_method("on_shoot"):
			get_parent().on_shoot()
	
	# Delay.
	var delay : float
	if shotDelayRandomize == true:
		delay = rng.randf_range(shotDelay * 0.75, shotDelay * 1.25)
	else:
		delay = shotDelay
		
	delay /= (global.enemySpeedMultiplier if affectedBySpeedMultiplier else 1.0)
		
	await get_tree().create_timer(delay).timeout
	
	# Shoot again.
	if healthComponent != null:
		if healthComponent.health > 0:
			shoot_loop()
	else:
		shoot_loop()
