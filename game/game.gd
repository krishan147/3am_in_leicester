extends Node3D

@onready var player = $CanvasLayer/player_main
@onready var fade = $CanvasLayer/fade
@onready var checkout_1 = $CanvasLayer/menu_ingame/SubViewportContainer/SubViewport/VBoxContainer/CheckBox_1
@onready var checkout_2 = $CanvasLayer/menu_ingame/SubViewportContainer/SubViewport/VBoxContainer/CheckBox_2
@onready var checkout_3 = $CanvasLayer/menu_ingame/SubViewportContainer/SubViewport/VBoxContainer/CheckBox_3
@onready var checkout_4 = $CanvasLayer/menu_ingame/SubViewportContainer/SubViewport/VBoxContainer/CheckBox_4
@onready var checkout_5 = $CanvasLayer/menu_ingame/SubViewportContainer/SubViewport/VBoxContainer/CheckBox_5
@onready var level = 0
@onready var playing = false
@onready var world_environment = $CanvasLayer/WorldEnvironment
@onready var random_engine_timer = $CanvasLayer/random_engine/random_engine_timer
@onready var fog_level = 0.4
@onready var wind_sound = $CanvasLayer/wind_sound
@onready var wind_fadein_anim = $CanvasLayer/wind_sound/fadein

@onready var dict_levels = {
	0:{
		"item_names":["BACON","COB","RED SAUCE"],
		"items":["bacon","cob_cobs","red_sauce"],
		"winning_item":"cob",
		"winning_item_name":"BACON COB"
	},
	1:{
		"item_names":["BEANS","CHEESE","TOAST"],
		"items":["botc_beans","botc_cheese","botc_toast"],
		"winning_item":"botc",
		"winning_item_name":"BEANS ON TOAST WITH CHEESE"
	},
	2:{
		"item_names":["MUSTARD","PASTRY","PORK"],
		"items":["pie_mustard","pie_pastry","pie_pork"],
		"winning_item":"pie_pie",
		"winning_item_name":"PORK PIE & MUSTARD"
	},
	3:{
		"item_names":["LAMB","ONION","SAUCE","TOMATOS","WRAP"],
		"items":["kebab_lamb","kebab_onion","kebab_sauce","kebab_tomato","kebab_wrap"],
		"winning_item":"kebab_kebab",
		"winning_item_name":"KEBAB"
	},
	4:{
		"item_names":["BASE","CHEESE","TOMATOS"],
		"items":["pizza_base","pizza_cheese","pizza_tomatos"],
		"winning_item":"pizza_pizza",
		"winning_item_name":"PIZZA"
		},
	5:{
		"item_names":["COLA","LEMON","ORANGE"],
		"items":["drinks_cola","drinks_lemon","drinks_orange"],
		"winning_item":"drinks_drinks",
		"winning_item_name":"PANDA POPS"
		},
	6:{
		"item_names":["MILK","SUGAR","TEA"],
		"items":["tea_milk","tea_sugar","tea_teabox"],
		"winning_item":"tea_tea",
		"winning_item_name":"TEA"
		},
	7:{
		"item_names":["COB","BUTTER","CHIPS","RED SAUCE"], 
		"items":["cob_bread","cob_butter","cob_chips","cob_redsauce"],
		"winning_item":"cob_chipcob",
		"winning_item_name":"CHIP COB"
		},
	8:{
		"item_names":["BACON","EGG","SAUSAGE","TOMATO"], 
		"items":["full_bacon","full_friedegg","full_sausage","full_tomatoes"],
		"winning_item":"full_english",
		"winning_item_name":"FULL ENGLISH"
		},
	9:{
		"item_names":["BARBECUE","SALTED","CHEESE & ONION","SPICY"], 
		"items":["all_barbecue","all_classic","all_onion","all_spicy"],
		"winning_item":"all_crisps",
		"winning_item_name":"CRISPS"
		},
	10:{
		"item_names":[], 
		"items":[],
		"winning_item":"",
		"winning_item_name":""
		}
}

var save_data = null
var list_items_collected = []

func _startGame():
	wind_fadein_anim.play("fadein")
	wind_sound.play()
	
func _stopGame():
	wind_sound.stop()

func _levelCompleted():
	level = level + 1
	save_data = GlobalOptions._loadGame()
	
	save_data["level"] = level
	save_data["player_position_x"] = player.position.x
	save_data["player_position_y"] = player.position.y + 1
	save_data["player_position_z"] = player.position.z
	save_data["fog"] = world_environment.environment.fog_density
	fog_level = float(world_environment.environment.fog_density)
	GlobalOptions._saveGame(save_data)
	
	if level >= 10:
		_completedGame()
	else:
		random_engine_timer.start()
		list_items_collected = []
		_changeLevel(level)
		random_engine_timer.start()

func _changeLevel(change):
	level = change
	var list_checkboxes = [checkout_1, checkout_2, checkout_3, checkout_4, checkout_5]
	for checkbox in list_checkboxes:
		checkbox.visible = false
	_changeCheckboxes(level)
	_showItems(level)
	
func _getLevel():
	return level
	
func _completedGame():
	player._canMove(false)
	player._playDancingRunningMan()

func _ready():
	fade.play("fade_to_normal")

func _physics_process(delta):
	get_tree().call_group("enemies", "_updateTargetLocation", player)
	
func _changeCheckboxes(level):
	_untickCheckBoxes()
	var list_checkboxes = [checkout_1, checkout_2, checkout_3, checkout_4, checkout_5]
	var list_objects = dict_levels[int(level)]["item_names"]
	var no_of_objects = len(dict_levels[int(level)]["item_names"])
	list_checkboxes = list_checkboxes.slice(0, no_of_objects)
	var x = 0
	
	for checkbox in list_checkboxes:
		checkbox.text = list_objects[x]
		checkbox.visible = true
		x = x + 1

func _changePlaying(change):
	playing = change

func _getPlayingState():
	return playing

func _showItems(level):
	for object in dict_levels[int(level)]["items"]:
		get_node("CanvasLayer/items/" + str(object))._activate()
		
func _untickCheckBoxes():
	var list_checkboxes = [checkout_1, checkout_2, checkout_3, checkout_4, checkout_5]
	for collected_item_checkout in list_checkboxes:
		collected_item_checkout.button_pressed = false

func _itemCollectedCheck(item_collected): # tick box, message to pop up, check if we have collected all 3 items
	var list_checkboxes = [checkout_1, checkout_2, checkout_3, checkout_4, checkout_5]
	var item_num = 0
	for item in dict_levels[int(level)]["items"]:
		
		if item_collected == item:
			list_items_collected.append(item)
			var collected_item_checkout = list_checkboxes[item_num]
			collected_item_checkout.button_pressed = true
			list_items_collected.sort()
			if list_items_collected == dict_levels[int(level)]["items"]:
				_itemSetCollected()
			return 0
		else:
			item_num = item_num + 1
	
func _itemSetCollected():

		var winning_item_name = dict_levels[int(level)]["winning_item_name"]
		random_engine_timer.stop()
		_reduceFog()
		if level >= 9:
			player._startMessages(["YOU HAVE " +  str(winning_item_name), "FOG REDUCED", "YOU ARE NOW SOBER"])
		else:
			var next_winning_item_name =  dict_levels[int(level) + 1]["winning_item_name"]
			var next_winning_item_name_sentence = null
			if next_winning_item_name == "PANDA POPS":
				next_winning_item_name_sentence = "GET PANDA POPS"
			elif next_winning_item_name == "CRISPS":
				next_winning_item_name_sentence = "GET CRISPS"
			else:
				next_winning_item_name_sentence = "MAKE " + next_winning_item_name
			
			player._startMessages(["YOU HAVE A " +  str(winning_item_name), "FOG REDUCED", next_winning_item_name_sentence])
			
		var winning_item = dict_levels[int(level)]["winning_item"]
		get_node("CanvasLayer/items/" + winning_item)._activate()


func _changeFog(change):
	fog_level = level
	world_environment.environment.fog_density = change


func _resetFog():
	world_environment.environment.fog_density = 0.4
	
func _reduceFog():
	world_environment.environment.fog_density =  fog_level - 0.04

func _on_wind_sound_finished():
	wind_fadein_anim.stop()
	wind_sound.play()
