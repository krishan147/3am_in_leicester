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
@onready var menu_buttons = $"../menu/menu_buttons"
@onready var game = $"../.."

#func _ready():
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
			menu_buttons.visible = true
			game._changePlaying(false)
			
	elif game._getPlayingState() == false:
		if Input.is_action_just_pressed("esc_menu"):
			can_move = true
			menu_buttons.visible = false
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
		var save_data = GlobalOptions._saveGameTemplate()
		save_data["player_location"] = self.position
		GlobalOptions._saveGame(save_data)


