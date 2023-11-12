extends Node

func _ready():
	global.save_high_score()
	await get_tree().create_timer(5).timeout
	end()
	
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		end()
		
func end():
	global.go_to_main_menu()
