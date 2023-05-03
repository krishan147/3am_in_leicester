extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var sensitivity = 0.1
#@onready var camera = $Camera3D
@onready var camera_pivot = $camera_pivot
@onready var animation_tree = $AnimationTree
@onready var state_machine =  animation_tree["parameters/playback"]

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	state_machine.travel("idle")
	
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(event.relative.x*sensitivity))
		camera_pivot.rotate_x(deg_to_rad(-event.relative.y*sensitivity))

func _physics_process(delta):
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		state_machine.travel("slow_run")
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
