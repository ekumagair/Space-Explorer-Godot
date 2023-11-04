extends BaseNPC

@export var turnAroundOnLedges : bool = true
@export var hasShootingAnimation : bool = false
@export var animationWalk = "default"
@export var animationFire = "fire"
@export var fireAnimationDuration = 0.25

var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")
var fireAnimationTimer : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	baseScale = $AnimatedSprite2D.scale
	active = false
	check_difficulty()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	base_npc_process()
	
	# Call move function.
	if active == true:
		move_npc(delta)
	
	# Call turn around.
	detect_turn_around()
	
	# Mirror sprite depending on direction.
	if mirrorSprite == true:
		$AnimatedSprite2D.scale.x = baseScale.x * direction * -1
		
	if fireAnimationTimer > 0:
		fireAnimationTimer -= delta

func move_npc(delta):
	velocity.x = speed * direction * (global.enemySpeedMultiplier if affectedBySpeedMultiplier else 1.0)
	velocity.y += gravity * delta
	move_and_slide()
	
	if fireAnimationTimer <= 0 and hasShootingAnimation == true:
		$AnimatedSprite2D.play(animationWalk)

func detect_turn_around():
	if not $RayCastRoot/RayCastFloor.is_colliding() and is_on_floor() and turnAroundOnLedges == true:
		turn_around()
		
	if is_on_wall():
		turn_around()
	
func turn_around():
	direction *= -1
	$RayCastRoot.scale.x *= -1

func on_shoot():
	fireAnimationTimer = fireAnimationDuration
	$AnimatedSprite2D.play(animationFire)
