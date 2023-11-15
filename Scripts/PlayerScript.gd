extends CharacterBody2D

const bulletPath = preload('res://Prefabs/Bullet.tscn')
#const bulletPath = preload('res://Prefabs/MonsterShot.tscn')
const laserPath = preload('res://Prefabs/Laser.tscn')
const fireWaitDelay = 0.3
const fireAnimationDuration = 0.2

@export var speed : float = 100.0
@export var jumpVelocity : float = -150
@export var jumpTimeDefault : float = 0.3
@export var gravityMultiplier : float = 0.8
@export var soundStreamShot : Array[AudioStream]

@onready var animatedSprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var healthScript = $HealthComponent
@onready var soundJump = $SoundJump
@onready var soundShot = $SoundShot

var jumpTime : float = 0.0
var horizontalVector : int = 1
var fireWait : float = 0.0
var fireAnimationTimer : float = 0.0
var freeze : bool = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction : Vector2 = Vector2.ZERO

func _ready():
	global.playerReference = self
	global.playerHealth = healthScript
	global.finishedLevel = false
	global.playerDied = false
	jumpTime = 0.0
	freeze = false
	
	match global.difficulty:
		0:
			# Normal difficulty.
			global.enemySpeedMultiplier = 1.0
			
		1:
			# Hard difficulty.
			global.enemySpeedMultiplier = 2.0
			
	if global.hasCheckpoint == true:
		global_position = global.checkpointPos
	
func _process(delta):
	if Input.is_action_just_pressed("Fire") and fireWait <= 0 and global.finishedLevel == false and freeze == false:
		shoot()
		
	if fireWait > 0:
		fireWait -= delta

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * gravityMultiplier * delta
		if fireAnimationTimer <= 0:
			animatedSprite.play("jump")

	# Handle Jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor() and global.finishedLevel == false and freeze == false:
		jumpStart()
		
	jumpContinue(delta)

	# Get the input direction and handle the movement/deceleration.
	if global.finishedLevel == false and freeze == false:
		direction.x = Input.get_axis("WalkLeft", "WalkRight")
	else:
		direction.x = 0
		
	if direction:
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	if freeze == false:
		move_and_slide()
		update_animation(delta)
		update_facing_direction()

func update_animation(delta):
	if fireAnimationTimer <= 0:
		if is_on_floor():
			if direction != Vector2.ZERO:
				animatedSprite.play("walk")
			else:
				animatedSprite.play("idle")
	else:
		fireAnimationTimer -= delta

func update_facing_direction():
	if direction.x > 0:
		animatedSprite.flip_h = false
		horizontalVector = 1
	elif direction.x < 0:
		animatedSprite.flip_h = true
		horizontalVector = -1
	
func jumpStart():
	jumpTime = jumpTimeDefault
	soundJump.play()

func jumpContinue(delta):
	if jumpTime > 0.0:
		jumpTime -= delta
		
		velocity.y = jumpVelocity
		
		if Input.is_action_pressed("Jump") == false or is_on_ceiling_only():
			jumpTime = 0.0
			
func shoot():
	var projectile
	if global.upgrade == 0:
		projectile = bulletPath.instantiate()
	elif global.upgrade == 1:
		projectile = laserPath.instantiate()
	
	get_tree().root.add_child(projectile)
	projectile.position.x = self.position.x + (2.0 * horizontalVector)
	projectile.position.y = self.position.y
	projectile.direction.x = horizontalVector
	
	fireWait = fireWaitDelay
	fireAnimationTimer = fireAnimationDuration
	animatedSprite.play("fire")
	
	soundShot.stop()
	soundShot.stream = soundStreamShot[global.upgrade]
	soundShot.play()

func _on_area_2d_body_entered(body):
	if body.has_method("move_npc"):
		healthScript.change_health(-1)

func on_change_health(amount):
	if amount < 0:
		global.upgrade = 0

func on_finish_level():
	healthScript.invulnerable = true
