extends CanvasLayer

@onready var scoreNumber = %ScoreNumber

func _on_ready():
	self.visible = true

func _process(delta):
	scoreNumber.text = str(global.score)
