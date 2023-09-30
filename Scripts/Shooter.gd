extends Node

@export var waitUntilOnScreen : bool = true
@export var shotPath : PackedScene
@export var direction : Vector2
@export var shotDelay : float = 2.0
@export var shotDelayRandomize : bool = true
@export var spawnOffset : Vector2

var active : bool = false
var startedLoop : bool = false
var rng = RandomNumberGenerator.new()

func _ready():
	active = false
	startedLoop = false

func _process(delta):
	if waitUntilOnScreen == true:
		if get_parent().get_node("VisibleOnScreenNotifier2D").is_on_screen():
			active = true
	else:
		active = true
		
	if active == true and startedLoop == false and get_parent().get_node("VisibleOnScreenNotifier2D").is_on_screen():
		startedLoop = true
		shoot_loop()

func shoot_loop():
	var projectile
	projectile = shotPath.instantiate()
	
	if direction == Vector2.ZERO:
		projectile.direction.x = get_parent().direction
	else:
		projectile.direction = direction
		
	get_tree().root.add_child(projectile)
	projectile.global_transform = self.global_transform
	projectile.position.y += spawnOffset.y
	
	var delay : float
	
	if shotDelayRandomize == true:
		delay = rng.randf_range(shotDelay * 0.75, shotDelay * 1.25)
	else:
		delay = shotDelay
		
	await get_tree().create_timer(delay).timeout
	
	if get_parent().has_node("HealthComponent"):
		if get_parent().get_node("HealthComponent").health > 0:
			shoot_loop()
	else:
		shoot_loop()
