extends Control

onready var scene_tree = get_tree()
onready var pause_overlay = get_node("ColorRect")

var paused = false setget set_paused

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		self.paused = not paused
		scene_tree.set_input_as_handled()

func set_paused(val: bool):
	print(1)
	paused = val
	scene_tree.paused = paused
	pause_overlay.visible = paused


func _on_Button_button_up():
	self.paused = false
	PlayerData.reset()
	get_tree().reload_current_scene()
	
