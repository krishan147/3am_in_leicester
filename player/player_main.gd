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

#func _ready():
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
			
		if Input.is_action_just_pressed("jump"):
			velocity.y = 3
		
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
		
		#if not is_on_floor():
		velocity.y -= gravity * delta
		
		if direction:
			animation_player.play("slow_run")
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			
			player.rotation.y = lerp_angle(player.rotation.y, atan2(velocity.x, velocity.z), LERP_VAL)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
			animation_player.play("idle")
		move_and_slide()
		
func _playStandUp():
	animation_player.play("standing_up")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "standing_up":
		_canMove(true)

func _on_pickup_area_area_entered(area):
	game._itemCollectedCheck(area.get_parent().name)
	area.get_parent()._deactivate()

func _on_pickup_area_area_exited(area):
	pass # Replace with function body.

var list_messages = []
var x_messages = 0
@onready var player_messages = $player_messages
@onready var messages_timer = $messages_Timer

func _startMessages(messages):
	list_messages = messages
	messages_timer.start()
	player_messages.text = list_messages[x_messages]
	x_messages = x_messages + 1
	
func _on_messages_timer_timeout():
	if x_messages == len(list_messages):
		messages_timer.stop()
		x_messages = 0
		list_messages = 0
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
	














