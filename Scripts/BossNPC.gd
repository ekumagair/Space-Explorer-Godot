extends FlyingNPC

@export var startDelay : float
@export var postStartAnimation = ""
@export var gameEndsOnDeath = true

var startTimer : float

func _ready():
	check_difficulty()
	check_shooter()
	allowMovement = false
	shooterComponent.allowShot = false
	startTimer = startDelay

func _process(delta):
	if visibilityNotifier.is_on_screen():
		startTimer -= delta
	
	if startTimer <= 0 and allowMovement == false:
		animatedSprite.play(postStartAnimation)
		allowMovement = true
		shooterComponent.allowShot = true

func _physics_process(delta):
	move_npc(delta)

func on_death():
	if gameEndsOnDeath == true:
		global.playerReference.freeze = true
		global.playerHealth.invulnerable = true
		global.win_game(true)
