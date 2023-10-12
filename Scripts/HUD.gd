extends CanvasLayer

@onready var scoreNumber = %ScoreNumber

func _on_ready():
	set_hud_text()
	self.visible = true

func _process(delta):
	set_hud_text()

func set_hud_text():
	scoreNumber.text = str(global.score)
