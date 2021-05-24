extends Node2D

var selected = false setget set_selected
var prew_name:String
var prompt:String
var access = true

func _on_TextureButton_button_up():
	self.selected = !selected

func set_selected(val: bool):
	selected = val
	if selected and access:
		$TextureButton/AnimatedSprite.animation = "selected"
	elif not access:
		get_parent().get_parent().open_prompt(prompt)
	else:
		$TextureButton/AnimatedSprite.animation = "default"

func set_prewiew(prew):
	var inst = prew.instance()
	prew_name = inst.prew_name
	if not inst.is_access:
		prompt = inst.prompt
		$Access.visible = true
		access = false
	inst.scale = Vector2(5,5)
	$TextureButton/Label.text = prew_name
	$TextureButton/Position2D.add_child(inst)
