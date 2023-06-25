extends Node3D

@onready var rotation_activate = false
@onready var zoom_in_activate = false
@onready var x = 1
@onready var y = 1
@onready var z = 1
@onready var zoom_speed = 0.1
@onready var player = $"../../player_main"
@onready var winning_item_timer = $"../winning_item_Timer"
@onready var game = $"../../.."
@onready var collection_effect_1 = $collection_effect_1

func _process(delta):
	if rotation_activate == true:
		self.rotate(Vector3(0,1,0),0.01)
		
	if zoom_in_activate == true:
		x = x + zoom_speed
		y = y + zoom_speed
		z = z + zoom_speed
		self.scale = Vector3(x,y,z)
		
		if self.scale.x == 5:
			zoom_in_activate = false

func _activate():
	self.position.x = player.position.x
	self.position.y = player.position.y + 0.3
	self.position.z = player.position.z
	self.visible = true
	rotation_activate = true
	zoom_in_activate = true
	winning_item_timer.start()
	collection_effect_1._activate()

func _deactivate():
	self.visible = false
	rotation_activate = false
	zoom_in_activate = false
	x = 1
	y = 1
	z = 1

func _on_winning_item_timer_timeout():
	_deactivate()
	game._levelCompleted()
