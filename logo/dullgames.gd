extends Node2D
var fade_out = false
var dull_color = 1
@onready var game = $".."
@onready var canvas = $"../CanvasLayer"
@onready var buttons = $"../CanvasLayer/menu/menu_buttons"
@onready var title = $"../CanvasLayer/menu/title"

func _process(delta):
	if fade_out == true:
		dull_color = dull_color - 0.01
		get_node("dull/games").modulate = Color(dull_color, dull_color, dull_color)
		get_node("dull").modulate = Color(dull_color, dull_color, dull_color)
		
		if dull_color <= 0:
			fade_out = false
			canvas.visible = true
			print ("herere")
			self.visible = false
			game._startGameMenu()
			buttons.visible = true
			title.visible = true

func _on_timergames_timeout():
	get_node("dull/games").visible = true

func _on_timerdull_timeout():
	get_node("dull").visible = true

func _on_timersound_timeout():
	get_node("AudioStreamPlayer").play()

func _on_timerfadeout_timeout():
	fade_out = true
