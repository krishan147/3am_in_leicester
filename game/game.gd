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

@onready var dict_levels = {
	0:{
		"item_names":["BACON","COB","RED SAUCE"],
		"items":["bacon","cob_cobs","red_sauce"], # make sure list is alphabetised
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
		"item_names":["BREAD","BACON","RED SAUCE"],
		"items":["bread","bacon","red_sauce"],
		"winning_item":"sandwich",
		"winning_item_name":"SANDWICH"
	},
	3:{
		"item_names":["BREAD","BACON","RED SAUCE"],
		"items":["bread","bacon","red_sauce"],
		"winning_item":"sandwich",
		"winning_item_name":"SANDWICH"
	},
	
}

var save_data = null
var list_items_collected = []

func _levelCompleted():
	level = level + 1
	save_data = GlobalOptions._loadGame()
	save_data["level"] = level
	save_data["player_position_x"] = player.position.x
	save_data["player_position_y"] = player.position.y
	save_data["player_position_z"] = player.position.z
	GlobalOptions._saveGame(save_data)
	player._startMessages(["MAKE " + dict_levels[level]["winning_item_name"]])
	list_items_collected = []
	_changeLevel(level)

func _changeLevel(change):
	level = change
	var list_checkboxes = [checkout_1, checkout_2, checkout_3, checkout_4, checkout_5]
	for checkbox in list_checkboxes:
		checkbox.visible = false
	_changeCheckboxes(level)
	_showItems(level)

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
			_itemSetCollected()
			return 0
		else:
			item_num = item_num + 1
	
func _itemSetCollected():
	list_items_collected.sort()
	
	if list_items_collected == dict_levels[int(level)]["items"]:
		var winning_item_name = dict_levels[int(level)]["winning_item_name"]
		player._startMessages(["YOU HAVE A " +  str(winning_item_name)])
		var winning_item = dict_levels[int(level)]["winning_item"]
		get_node("CanvasLayer/items/" + winning_item)._activate()
















