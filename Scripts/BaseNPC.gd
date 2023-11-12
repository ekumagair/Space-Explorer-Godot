extends CharacterBody2D

class_name BaseNPC

@export var speed : float = 32
@export var direction : int = -1
@export var mirrorSprite : bool = false
@export var waitUntilOnScreen : bool = true
@export var affectedBySpeedMultiplier : bool = true

@export var appearOnDifficulty : Array[bool] = [true, true]

@onready var visibilityNotifier = $VisibleOnScreenNotifier2D
@onready var animatedSprite = $AnimatedSprite2D

var baseScale = Vector2(1, 1)
var active : bool = false
var allowMovement : bool = true
var shooterComponent

func check_shooter():
	if has_node("ShooterComponent"):
		shooterComponent = $ShooterComponent

func check_difficulty():
	if appearOnDifficulty[global.difficulty] == false:
		queue_free()

func base_npc_process():
	if waitUntilOnScreen == true:
		if visibilityNotifier.is_on_screen():
			active = true
	else:
		active = true
