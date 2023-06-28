extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D
@onready var animation_player = $enemy/AnimationPlayer
@onready var SPEED = 0.5
@onready var start = false

#func _ready():
#	start = false

func _start():
	animation_player.play("mixamocom")
	self.visible = true
	start = true

func _physics_process(delta):
	if start == true:
		var current_location = global_transform.origin
		var next_location = nav_agent.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * SPEED
		velocity = new_velocity
		move_and_slide()
		
func _stop():
	start = false
	animation_player.stop()
		
		
func _end():
	animation_player.stop()
	self.visible = false
	start = false
	
func _updateTargetLocation(target):
	nav_agent.set_target_position(target.global_transform.origin)
	look_at(target.global_transform.origin,Vector3.UP)
