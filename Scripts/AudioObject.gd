extends AudioStreamPlayer

enum AudioType {SFX, MUSIC}

@export var destroyOnFinish : bool = true
@export var audioType : AudioType = AudioType.SFX

func _ready():
	if audioType == AudioType.MUSIC:
		global.musicReference = self

func _on_finished():
	if destroyOnFinish == true:
		queue_free()

func stop_sound():
	stop()
