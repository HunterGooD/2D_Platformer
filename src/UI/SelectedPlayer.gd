extends Control

onready var border = preload("res://src/UI/PlayerSelect.tscn")
var dir_name = "res://src/prewiew/"

func _ready():
	dir_contents(dir_name)

func dir_contents(path):
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		var index = 0
		var y = 0
		while file_name != "":
			if !dir.current_is_dir():
				var loadfile = load(dir_name + file_name)
				var border_inst = border.instance()
				border_inst.set_prewiew(loadfile)
				if index == 4:
					y = 400
					index = 0
				border_inst.position = $ColorRect/Position2D.global_position + Vector2(300* index, y)
				$ColorRect.add_child(border_inst)
				index += 1
			file_name = dir.get_next()
			
	else:
		print("An error occurred when trying to access the path.")

func open_prompt(text:String):
	$ColorRect2/TextureRect2/Label.text = text
	$ColorRect2.visible = true

func _on_TextureButton_button_up():
	$ColorRect2.visible = false


func _on_Back_button_up():
	get_tree().change_scene("res://src/UI/MainMenu.tscn")
