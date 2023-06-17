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
		"objects":["BREAD","BACON", "RED SAUCE"]
	},
	1:{
		"objects":["qwe","qwe", "qwe"]
	},
	2:{
		"objects":["qwe","qwe", "qwe"]
	},
	3:{
		"objects":["qwe","qwe", "qwe"]
	},
	
}

func _changeLevel(change):
	level = change
	var list_checkboxes = [checkout_1, checkout_2, checkout_3, checkout_4, checkout_5]
	for checkbox in list_checkboxes:
		checkbox.visible = false
	_changeCheckboxes()

func _ready():
	fade.play("fade_to_normal")

func _physics_process(delta):
	get_tree().call_group("enemies", "_updateTargetLocation", player)
	
func _changeCheckboxes():
	var list_checkboxes = [checkout_1, checkout_2, checkout_3, checkout_4, checkout_5]
	var list_objects = dict_levels[level]["objects"]
	var no_of_objects = len(dict_levels[level]["objects"])
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


















