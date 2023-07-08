extends Node

var file_location = OS.get_user_data_dir() + "/save.save"

func _ready():
	if FileAccess.file_exists(file_location):
		pass
	else:
		FileAccess.open(file_location, FileAccess.WRITE_READ)
		
func _saveGame(data):
	var file = FileAccess.open(file_location, FileAccess.WRITE)
	file.store_line(JSON.stringify(data))
	file.close()

func _loadGame():
	var file = FileAccess.open(file_location, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	file.close()
	return data

func _saveGameTemplate():
	var save_dict = {
		"player_position_x": 1,
		"player_position_y": 1,
		"player_position_z": 1,
		"level":0,
		"jump_power_unlocked":0,
		"fog":0.4
		}
	return save_dict
