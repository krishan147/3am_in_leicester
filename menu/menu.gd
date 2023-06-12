extends Node3D
@onready var options = $menu_buttons/SubViewport/options
@onready var vol_num = 50
@onready var camera_menu = $menu_Camera3D
@onready var camera_player = $"../player_main/SpringArmPivot/SpringArm3D/Camera3D"
@onready var menu_buttons = $menu_buttons
@onready var fade = $"../fade"
@onready var timer_load = $"../Timer_load"
@onready var player = $"../player_main"

func _process(delta):
	pass

func _on_options_pressed():
	options.visible = true


func _on_close_options_pressed():
	options.visible = false


func _on_exit_pressed():
	get_tree().quit()


func _on_volume_h_slider_value_changed(value): # all
	vol_num = _volumeLookup(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), vol_num)


func _on_volume_h_slider_2_value_changed(value): # music
	vol_num = _volumeLookup(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("music"), vol_num)

func _volumeLookup(dial_num):
	
	var dict_volume = {
		100:6,
		90:-1,
		80:-8,
		70:-15,
		60:-22,
		50:-29,
		40:-44,
		30:-51,
		20:-65,
		10:-79,
		0:-80,
	}
	
	return dict_volume[int(dial_num)]

func _on_new_game_button_down():
	fade.play("fade_to_black")
	menu_buttons.visible = false
	self.visible = false
	timer_load.start()

func _on_timer_load_timeout():
	fade.play("fade_to_normal")
	camera_menu.current = false
	camera_player.current = true
	player._canMove(false)
	player._playStandUp()
