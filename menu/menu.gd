extends Node3D
@onready var options = $menu_buttons/SubViewport/options
@onready var vol_num = 50
@onready var camera_menu = $menu_Camera3D
@onready var camera_player = $"../player_main/SpringArmPivot/SpringArm3D/Camera3D"
@onready var menu_buttons = $menu_buttons
@onready var fade = $"../fade"
@onready var timer_load = $"../Timer_load"
@onready var player = $"../player_main"
@onready var timer_intro = $"../Timer_intro"
@onready var player_messages = $"../player_main/player_messages"
@onready var x_intro = 0
@onready var game = $"../.."
@onready var menu_ingame_container = $"../menu_ingame/SubViewportContainer"
@onready var continue_btn = $menu_buttons/SubViewport/menu/continue
@onready var new_game_btn = $menu_buttons/SubViewport/menu/new_game
@onready var options_btn = $menu_buttons/SubViewport/menu/options
@onready var exit_btn = $menu_buttons/SubViewport/menu/exit
@onready var title = $title
@onready var game_over = $"../game_over"
@onready var random_engine_timer = $"../random_engine/random_engine_timer"
@onready var enemy_main = $"../enemy_main"
@onready var menu_sound = $menu_sound
@onready var horror_sound = $horror_sound

func _process(delta):
	pass
	
func _ready():
	_continueCheck()
	var save_data = GlobalOptions._loadGame()

func _on_options_pressed():
	menu_sound.play()
	options.visible = true

func _on_close_options_pressed():
	menu_sound.play()
	options.visible = false

func _on_exit_pressed():
	menu_sound.play()
	get_tree().quit()

func _on_volume_h_slider_value_changed(value): # all
	menu_sound.play()
	vol_num = _volumeLookup(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), vol_num)

func _on_volume_h_slider_2_value_changed(value): # music
	menu_sound.play()
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

var new_game_check = 0
@onready var click_again = $menu_buttons/SubViewport/click_again

func _on_new_game_button_down():
	menu_sound.play()
	if new_game_check == 0:
		new_game_check = 1
		click_again.visible = true
	else:
		horror_sound.play() 
		var save_data_template = GlobalOptions._saveGameTemplate()
		GlobalOptions._saveGame(save_data_template)
		fade.play("fade_to_black")
		_disableMenu()
		player.position = Vector3(25.5, 2.6, -50.7)
		timer_load.start()
		new_game_check = 0
		random_engine_timer.start()
		enemy_main._end()
		game._resetFog()
		game._startGame()

func _on_timer_load_timeout():
	timer_load.stop()
	fade.play("fade_to_normal")
	camera_menu.current = false
	camera_player.current = true
	player._canMove(false)
	player._playStandUp()
	timer_intro.start()

func _on_timer_intro_timeout():
	if x_intro == 0:
		player_messages.text = "GET UP!"
		timer_intro.start()
	elif x_intro == 1:
		player_messages.text = "HURRY!"
		timer_intro.start()
	elif x_intro == 2:
		player_messages.text = "YOU'RE HUNGOVER!"
		timer_intro.start()
	elif x_intro == 3:
		player_messages.text = "MAKE A BACON COB!"
		timer_intro.start()
	else:
		player_messages.text = ""
		x_intro = 0
		timer_intro.stop()
		game._changeLevel(0)
		menu_ingame_container.visible = true
		game._changePlaying(true)
		
	x_intro = x_intro + 1
	
func _on_continue_pressed():
	var save_data = GlobalOptions._loadGame()
	_disableMenu()
	player.position.x = save_data["player_position_x"]
	player.position.y = save_data["player_position_y"]
	player.position.z = save_data["player_position_z"]
	game._changeFog(float(save_data["fog"]))
	fade.play("fade_to_normal")
	camera_menu.current = false
	camera_player.current = true
	player._canMove(true)
	game._changePlaying(true)
	menu_ingame_container.visible = true
	game._changeLevel(save_data["level"])
	random_engine_timer.start()
	enemy_main._end()
	game._startGame()
	
func _continueCheck():
	var save_data = GlobalOptions._loadGame()
	
	if save_data["player_position_x"] == 1:
		continue_btn.disabled = true
		continue_btn.visible = false
	else:
		pass

func _disableMenu():
	self.visible = false
	click_again.visible = false
	menu_buttons.visible = false
	continue_btn.disabled = true
	new_game_btn.disabled = true
	options_btn.disabled = true
	exit_btn.disabled = true
	title.visible = false
	
func _enableMenu():
	self.visible = true
	menu_buttons.visible = true
	continue_btn.disabled = false
	new_game_btn.disabled = false
	options_btn.disabled = false
	exit_btn.disabled = false
	title.visible = true
	
func _on_game_over_timer_timeout():
	game_over.visible = false
	_enableMenu()


func _on_menu_sound_finished():
	pass # Replace with function body.
