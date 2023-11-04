extends BaseNPC

func _ready():
	active = false
	check_difficulty()
	
func _process(delta):
	base_npc_process()
	
func _physics_process(delta):
	if active == true:
		move_npc(delta)

func move_npc(delta):
	velocity.x = speed * direction * (global.enemySpeedMultiplier if affectedBySpeedMultiplier else 1.0)
	move_and_slide()
