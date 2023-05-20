extends Node3D

@onready var player = $player_main


func _ready():
	pass

func _physics_process(delta):
	get_tree().call_group("enemies", "_updateTargetLocation", player)
