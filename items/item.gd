extends Node3D

@onready var collisionshape = $player_pickup/CollisionShape3D #get_node("player_pickup/CollisionShape3D")
@onready var rotation_activate = false
@onready var player = $"../../player_main"

func _process(delta):
	if rotation_activate == true:
		self.rotate(Vector3(0,1,0),0.01)

func _activate():
	collisionshape.set_deferred("disabled", false)
	self.visible = true
	rotation_activate = true
	
func _deactivate():
	collisionshape.set_deferred("disabled", true)
	self.visible = false
	rotation_activate = false

