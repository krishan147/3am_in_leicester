extends Node3D


@onready var list_random_unit = ["random_effect", "random_message", "get_chased"]

@onready var list_messages = ["YOU ARE NOT SOBER", "WHERE ARE YOU GOING?", "CAN LEND ME 36p PLEASE?", 
"YOU WILL NEVER BE SOBER", "THERE ARE GHOSTS SOMEWHERE", "KINGS ARE FOUND IN CAR PARKS", "WHY IS THERE A SPACE CENTRE?",
"EVERYTHING IS POINTLESS", "YOU WILL NEVER BE HAPPY", "YOU WILL NEVER SEE ANYTHING", "FOLLOW THE LIGHT", "NOT THAT LIGHT. FOLLOW THE OTHER LIGHT",
"SOMETIMES YOU SHOULD IGNORE MY ADVICE", "FOLLOW THE LIGHT","NOT THAT LIGHT. FOLLOW THE OTHER LIGHT","SOMETIMES YOU SHOULD IGNORE MY ADVICE"]
@onready var list_secs_range = range(60, 120)
@onready var random_engine_timer = $random_engine_timer
@onready var player = $"../player_main"
@onready var enemy = $"../enemy_main"
@onready var enemy_position_add = range(+3, +7)
@onready var enemy_position_sub = range(-7, -3)
@onready var list_enemy_position_add_sub = enemy_position_add + enemy_position_sub
@onready var random_effect_1 = $random_effect_1
@onready var random_effect_2 = $random_effect_2
@onready var random_effect_3 = $random_effect_3
@onready var random_effect_4 = $random_effect_4
@onready var list_random_effects = []

func _ready():
	list_random_effects.append(random_effect_4)
	list_random_effects.append(random_effect_4)
	list_random_effects.append(random_effect_4)

func _process(delta):
	pass

func _on_random_engine_timer_timeout():
	list_secs_range.shuffle()
	random_engine_timer.stop()
	random_engine_timer.wait_time = list_secs_range[0]
	random_engine_timer.start()
	list_random_unit.shuffle()
	_runRandom(list_random_unit[0])
	
func _runRandom(random_unit):
	if random_unit == "random_effect":
		_randomEffect()
	elif random_unit == "random_message":
		list_messages.shuffle()
		var temp_list = [list_messages[0]]
		player._startMessages(temp_list)
	elif random_unit == "get_chased":
		_getChased()
		
func _randomEffect():
	var player_x = player.position.x
	var player_z = player.position.z
	list_enemy_position_add_sub.shuffle()
	list_random_effects.shuffle()
	list_random_effects[0].position.x = player_x + list_enemy_position_add_sub[0]
	list_enemy_position_add_sub.shuffle()
	list_random_effects[0].position.z = player_z + list_enemy_position_add_sub[0]
	list_random_effects[0]._activate()
	
func _randomMessage():
	list_messages.shuffle()
	
func _getChased():
	var player_x = player.position.x
	var player_z = player.position.z
	list_enemy_position_add_sub.shuffle()
	enemy.position.x = player_x + list_enemy_position_add_sub[0]
	list_enemy_position_add_sub.shuffle()
	enemy.position.z = player_z + list_enemy_position_add_sub[0]
	#enemy.position.x = 26.074 # delete me  
	#enemy.position.z = -58.817 # delete me  
	enemy._start()
		
