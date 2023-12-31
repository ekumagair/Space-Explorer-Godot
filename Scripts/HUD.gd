extends CanvasLayer

@onready var scoreNumber = %ScoreNumber
@onready var levelNumber = %LevelNumber
@onready var livesNumber = %LivesNumber
@onready var pauseText = $Control/PauseText

func _on_ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	pauseText.hide()
	set_hud_text()
	global.hudControlReference = $Control
	self.visible = true

func _process(delta):
	set_hud_text()

func set_hud_text():
	scoreNumber.text = str(global.score)
	levelNumber.text = str(global.level)
	livesNumber.text = str(global.lives)
	
	if get_tree().paused == true:
		pauseText.show()
	else:
		pauseText.hide()
