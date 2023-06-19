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
		"item_names":["BREAD","BACON","RED SAUCE"],
		"items":["bread","bacon","red_sauce"],
		"winning_item":"sandwich"
	},
	1:{
		"item_names":["BREAD","BACON","RED SAUCE"],
		"items":["bread","bacon","red_sauce"],
		"winning_item":"sandwich"
	},
	2:{
		"item_names":["BREAD","BACON","RED SAUCE"],
		"items":["bread","bacon","red_sauce"],
		"winning_item":"sandwich"
	},
	3:{
		"item_names":["BREAD","BACON","RED SAUCE"],
		"items":["bread","bacon","red_sauce"],
		"winning_item":"sandwich"
	},
	
}

func _levelCompleted():
	level = level + 1

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

func _itemCollectedCheck(item_collected): # tick box, message to pop up, check if we have collected all 3 items
	var list_checkboxes = [checkout_1, checkout_2, checkout_3, checkout_4, checkout_5]
	var item_num = 0
	for item in dict_levels[int(level)]["items"]:
		
		if item_collected == item:
			var collected_item_checkout = list_checkboxes[item_num]
			collected_item_checkout.button_pressed = true
			_itemSetCollected()
			return 0
		else:
			item_num = item_num + 1
	

var items_collected = 0

func _itemSetCollected():
	items_collected = items_collected + 1
	
	if items_collected == len(dict_levels[int(level)]["items"]):
		var winning_item = dict_levels[int(level)]["winning_item"]
		




















