extends BaseNPC

class_name FlyingNPC

enum Flight {HORIZONTAL, VERTICAL, VERTICAL_LOOP}

@export var flightType : Flight

func _ready():
	active = false
	check_difficulty()
	check_shooter()
	
func _process(delta):
	base_npc_process()
	
func _physics_process(delta):
	if active == true:
		move_npc(delta)
		
func speed_value():
	return speed * direction * (global.enemySpeedMultiplier if affectedBySpeedMultiplier else 1.0)

func move_npc(delta):
	if allowMovement == false:
		return
	
	match flightType:
		Flight.HORIZONTAL:
			velocity.x = speed_value()
			
		Flight.VERTICAL:
			velocity.y = speed_value()
			
		Flight.VERTICAL_LOOP:
			velocity.y = speed_value()
			if global_position.y < 40 or global_position.y > 150:
				direction *= -1
				global_position.y += 2 * direction
	
	move_and_slide()
