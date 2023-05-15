extends Camera3D

@onready var timer = $Timer
@onready var z = null

#func _ready():
#	_start()

func _process(delta):
	pass

func _start():
	z = 16
	self.position = Vector3(42, 10, z)
	timer.start()
	
func _on_timer_timeout():
	self.position = Vector3(42, 10, z)
	z = z - 0.005
