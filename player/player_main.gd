extends CharacterBody3D

const SPEED = 1.5
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var sensitivity = 0.1
@onready var animation_tree = $AnimationTree
@onready var animation_player = get_node("player/AnimationPlayer")

@onready var spring_arm_pivot = $SpringArmPivot
@onready var spring_arm_3d = $SpringArmPivot/SpringArm3D
@onready var camera3d = $SpringArmPivot/SpringArm3D/Camera3D
@onready var camera_direction_x = null
@onready var player = $player
const LERP_VAL = 0.5
@onready var can_move = false
@onready var game = $"../.."
@onready var menu = $"../menu"
@onready var fade = $"../fade"
@onready var game_over = $"../game_over"
@onready var game_over_timer = $"../game_over_Timer"
@onready var menu_ingame_container = $"../menu_ingame/SubViewportContainer"
@onready var enemy = $"../enemy_main"
@onready var is_jumping = false
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

#	_startMessages(messages)
#	_start()

func _canMove(change):
	can_move = change
	
func _start():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	animation_player.play("idle")
	
func _input(event):
	if game._getPlayingState() == true:
		if event is InputEventMouseMotion:
			spring_arm_pivot.rotate_y(-event.relative.x * .005)
			spring_arm_3d.rotate_x(-event.relative.y * .005)
			
			if spring_arm_3d.rotation[0] >= 0.7:
				spring_arm_3d.rotation[0] = 0.7

			if spring_arm_3d.rotation[0] <= -1.4:
				spring_arm_3d.rotation[0] = -1.4
				
		if is_jumping == false:
			if Input.is_action_just_pressed("jump"):
				var level = game._getLevel()
				if level >= 10:
					velocity.y = 6
				else:
					velocity.y = 3
					
		if Input.is_action_just_pressed("forward"):
			footsteps_timer.start()
		elif Input.is_action_just_pressed("backward"):
			footsteps_timer.start()
		elif Input.is_action_just_pressed("left"):
			footsteps_timer.start()
		elif Input.is_action_just_pressed("right"):
			footsteps_timer.start()
		
		if Input.is_action_just_pressed("esc_menu"):
			can_move = false
			menu._enableMenu()
			game._changePlaying(false)
			
	elif game._getPlayingState() == false:
		if Input.is_action_just_pressed("esc_menu"):
			can_move = true
			menu._disableMenu()
			game._changePlaying(true)
	else:
		pass

func _physics_process(delta):
	
	if can_move == true:
	
		var input_dir = Input.get_vector("left", "right", "forward", "backward")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		direction = direction.rotated(Vector3.UP, spring_arm_pivot.rotation.y)
		
		if not is_on_floor():
			var level = game._getLevel()
			is_jumping = true
			if level >= 10:
				animation_player.play("floating")
			else:
				animation_player.play("falling_idle")
		else:
			is_jumping = false
			if direction:
				animation_player.play("slow_run")
				velocity.x = direction.x * SPEED
				velocity.z = direction.z * SPEED
				
				player.rotation.y = lerp_angle(player.rotation.y, atan2(velocity.x, velocity.z), LERP_VAL)
			else:
				footsteps_timer.stop()
				velocity.x = move_toward(velocity.x, 0, SPEED)
				velocity.z = move_toward(velocity.z, 0, SPEED)
				animation_player.play("idle")
			
		velocity.y -= gravity * delta
		move_and_slide()
		
func _playStandUp():
	animation_player.play("standing_up")
	
func _playDancingRunningMan():
	animation_player.play("dancing_running_man")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "standing_up":
		_canMove(true)
	elif anim_name == "dancing_running_man":
		animation_player.play("dancing step")
	elif anim_name == "dancing step":
		animation_player.play("breakdance_v2")
	elif anim_name == "breakdance_v2":
		_canMove(true)
		animation_player.play("idle")
		_startMessages(["YOU CAN NOW JUMP HIGHER"])
	else:
		pass
		
func _on_pickup_area_area_entered(area):
	if area.name == "play_too_much_ac":
		_startMessages(["YOU PLAY TOO MUCH ASSASSINS CREED"])
	else:
		game._itemCollectedCheck(area.get_parent().name)
		area.get_parent()._deactivate()

func _on_pickup_area_area_exited(area):
	pass # Replace with function body.

var list_messages = []
var x_messages = 0
@onready var player_messages = $player_messages
@onready var messages_timer = $messages_Timer
@onready var processing_messages = false

func _startMessages(messages):
	if processing_messages == false:
		processing_messages = true
		list_messages = messages
		messages_timer.start()
		
		player_messages.text = list_messages[x_messages]
		x_messages = x_messages + 1
	
func _on_messages_timer_timeout():
	if x_messages == len(list_messages):
		processing_messages = false
		messages_timer.stop()
		x_messages = 0
		list_messages = []
		player_messages.text = ""
	else:
		_startMessages(list_messages)

func _fallOver(): # GAME OVER
	menu_ingame_container.visible = false
	_canMove(false)
	animation_player.play("fall_over")
	game_over.visible = true
	fade.play("fade_to_black")
	game_over_timer.start()
	
func _on_pickup_area_body_entered(body):
	if body.name == "enemy_main":
		_fallOver()
		enemy._stop()
		
func _on_footsteps_timer_timeout():
	var list_steps = [footsteps1,footsteps2,footsteps3,footsteps4,footsteps5,footsteps6,footsteps7,footsteps8,footsteps9,footsteps10]
	list_steps.shuffle()
	list_steps.play()
		
#func _on_footsteps_timer_2_timeout():
#	footsteps1.play()






