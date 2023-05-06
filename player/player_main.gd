extends CharacterBody3D


const SPEED = 5.0
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

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	animation_player.play("idle")
	
func _input(event):
	
	if event is InputEventMouseMotion:
		spring_arm_pivot.rotate_y(-event.relative.x * .005)
		spring_arm_3d.rotate_x(-event.relative.y * .005)
		
		#camera_direction_x = camera3d.transform.basis.z.normalized()
		
		
		#spring_arm_3d.rotation.x = clamp(spring_arm_3d.rotation.x, -PI/4, -PI/4)
		
	if event is InputEventKey:
		print (event)
	
		
		

func _physics_process(delta):
	pass

	
	
	
	
	
	
	
	
	
#	var input_dir = Input.get_vector("left", "right", "forward", "backward")
#	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
#	if direction:
#
#		animation_player.play("slow_run")
#		print (camera_direction_x)
#		#velocity.x = camera_direction_x * SPEED
#		#velocity.x = direction.x * SPEED
#		#velocity.z = direction.z * SPEED
#
#		velocity = camera_direction_x
#
#		print ("current velocity ", velocity)
#
#	else:
#		velocity.x = move_toward(velocity.x, 0, SPEED)
#		velocity.z = move_toward(velocity.z, 0, SPEED)
#		animation_player.play("idle")
#
#	move_and_slide()
