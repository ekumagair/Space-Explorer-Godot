extends BaseNPC

@export var turnAroundOnLedges : bool = true

var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")

# Called when the node enters the scene tree for the first time.
func _ready():
	baseScale = $AnimatedSprite2D.scale
	active = false

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

func move_npc(delta):
	velocity.x = speed * direction
	velocity.y += gravity * delta
	move_and_slide()

func detect_turn_around():
	if not $RayCastRoot/RayCastFloor.is_colliding() and is_on_floor() and turnAroundOnLedges == true:
		turn_around()
		
	if is_on_wall():
		turn_around()
	
func turn_around():
	direction *= -1
	$RayCastRoot.scale.x *= -1
