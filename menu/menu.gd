extends Node3D
@onready var options = $menu_buttons/SubViewport/options


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_options_pressed():
	options.visible = true


func _on_close_options_pressed():
	options.visible = false


func _on_exit_pressed():
	get_tree().quit()


func _on_volume_h_slider_value_changed(value):
	print (value)


func _on_volume_h_slider_2_value_changed(value):
	print (value)


func _on_brightness_h_slider_value_changed(value):
	print (value)
