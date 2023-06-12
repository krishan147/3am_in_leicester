extends Node3D

@onready var player = $CanvasLayer/player_main
@onready var fade = $CanvasLayer/fade

func _ready():
	fade.play("fade_to_normal")

func _physics_process(delta):
	get_tree().call_group("enemies", "_updateTargetLocation", player)
	
