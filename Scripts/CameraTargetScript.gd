extends RemoteTransform2D

@export var follow : Node2D
@export var blockScrollLeft : bool = true

func _ready():
	if follow != null:
		global_position.y = follow.global_position.y

func _process(delta):
	if follow != null:
		if global_position.x < follow.global_position.x or blockScrollLeft == false:
			global_position.x = follow.global_position.x
