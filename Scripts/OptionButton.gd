extends GameMenuButton
class_name GameOptionButton

enum Restriction { NONE, DIFFICULTY }

@export var restriction : Restriction = Restriction.NONE
@export var value : int = 0
@export var valueMin : int = 0
@export var valueMax : int = 1
@export var valueIncrement : int = 1
@export var valueDisplay : Label
@export var valueDisplaySuffix : String
@export var valueDisplayNames : Array[String]

func _ready():
	set_value_text()

func _process(delta):
	if restriction == Restriction.DIFFICULTY:
		valueMax = global.unlockedDifficulty
	
	if get_viewport().gui_get_focus_owner() != null:
		if get_viewport().gui_get_focus_owner() == self:
			if Input.is_action_just_pressed("ui_left"):
				change_value(-valueIncrement)
				
			if Input.is_action_just_pressed("ui_right"):
				change_value(valueIncrement)

func change_value(increment : int):
	var canIncrement : bool = false
	
	if increment > 0 and value < valueMax:
		canIncrement = true
		
	if increment < 0 and value > valueMin:
		canIncrement = true
		
	if canIncrement == true:
		value += increment
		soundSelect.play()
	else:
		soundDeny.play()

	if value < valueMin:
		value = valueMin
	if value > valueMax:
		value = valueMax
	
	set_value_text()
	savedata.save_game()

func set_value_text():
	if valueDisplay != null:
		if len(valueDisplayNames) > 0:
			valueDisplay.text = valueDisplayNames[value]
		else:
			valueDisplay.text = str(value) + valueDisplaySuffix
