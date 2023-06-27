extends Node3D


#@onready var list_random_unit = ["random_effect", "random_message", "get_chased"]
@onready var list_random_unit = ["get_chased"]

@onready var list_messages = ["YOU ARE NOT SOBER", "WHERE ARE YOU GOING?", "CAN LEND ME 36p PLEASE?", 
"YOU WILL NEVER BE SOBER", "THERE ARE GHOSTS SOMEWHERE", "KINGS ARE FOUND IN CAR PARKS", "WHY IS THERE A SPACE CENTRE?",
"EVERYTHING IS POINTLESS", "YOU WILL NEVER BE HAPPY", "YOU WILL NEVER SEE ANYTHING"]
#@onready var list_secs_range = range(60, 120)
@onready var list_secs_range = range(15, 20)
@onready var random_engine_timer = $random_engine_timer
@onready var player = $"../player_main/player_messages"
@onready var enemy = $"../enemy_main"
@onready var enemy_position_add = range(+3, +7)
@onready var enemy_position_sub = range(-7, -3)

func _ready():
	pass


func _process(delta):
	pass


func _on_random_engine_timer_timeout():
	list_secs_range.shuffle()
	random_engine_timer.wait_time = list_secs_range[0]
	list_random_unit.shuffle()
	_runRandom(list_random_unit[0])
	
func _runRandom(random_unit):
	if random_unit == "random_effect":
		pass
	elif random_unit == "random_message":
		pass
	elif random_unit == "get_chased":
		_getChased()
		
func _randomEffect():
	pass
	
func _randomMessage():
	list_messages.shuffle()
	
func _getChased():
	var player_x = player.position.x
	var player_y = player.position.y
	var list_enemy_position_add_sub = enemy_position_add + enemy_position_sub
	list_enemy_position_add_sub.shuffle()
	enemy.position.x = player_x + list_enemy_position_add_sub[0]
	list_enemy_position_add_sub.shuffle()
	enemy.position.y = player_y + list_enemy_position_add_sub[0]
	enemy.start()
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
