extends Button
class_name GameMenuButton

@export var playSelectSoundOnStart : bool = false

@onready var soundSelect = $SoundSelect

func _on_focus_entered():
	if  Time.get_ticks_msec() > 1000 or playSelectSoundOnStart == true:
		soundSelect.play()
