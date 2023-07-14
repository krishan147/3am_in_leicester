extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D
@onready var animation_player = $enemy/AnimationPlayer
@onready var SPEED = 0.5
@onready var start = false
@onready var collisionshape = $CollisionShape3D
@onready var enemy_chase_timer = $"../enemy_chase_Timer"
@onready var footsteps1 = $footsteps/footsteps1
@onready var footsteps2 = $footsteps/footsteps2
@onready var footsteps3 = $footsteps/footsteps3
@onready var footsteps4 = $footsteps/footsteps4
@onready var footsteps5 = $footsteps/footsteps5
@onready var footsteps6 = $footsteps/footsteps6
@onready var footsteps7 = $footsteps/footsteps7
@onready var footsteps8 = $footsteps/footsteps8
@onready var footsteps9 = $footsteps/footsteps9
@onready var footsteps10 = $footsteps/footsteps10
@onready var footsteps_timer = $footsteps/footsteps_Timer

#func _ready():
#	start = false

func _start():
	footsteps_timer.start()
	animation_player.play("mixamocom")
	self.visible = true
	start = true
	collisionshape.set_deferred("disabled", false)
	enemy_chase_timer.start()

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
	_end()
		
		
func _end():
	footsteps_timer.stop()
	animation_player.stop()
	self.visible = false
	start = false
	collisionshape.set_deferred("disabled", true)
	
func _updateTargetLocation(target):
	nav_agent.set_target_position(target.global_transform.origin)
	look_at(target.global_transform.origin,Vector3.UP)


func _on_enemy_chase_timer_timeout():
	_end()


func _on_footsteps_timer_timeout():
	var list_steps = [footsteps1,footsteps2,footsteps3,footsteps4,footsteps5,footsteps6,footsteps7,footsteps8,footsteps9,footsteps10]
	list_steps.shuffle()
	list_steps[0].play()
