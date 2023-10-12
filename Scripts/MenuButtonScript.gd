extends Button

@export var playSelectSoundOnStart : bool = false

func _on_focus_entered():
	if  Time.get_ticks_msec() > 500 or playSelectSoundOnStart == true:
		$SoundSelect.play()
