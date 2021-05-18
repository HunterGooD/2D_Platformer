extends "res://src/Objects/UsingObjects.gd"

var is_pick = false

func _physics_process(delta):
	handl_input()
		
func handl_input():
	if Input.is_action_just_pressed("use") and next_to_player:
		action()

func action():
	if PlayerData.rune:
		$Label.text = "Вы использовали руну"
		$AnimationPlayer.play("fade_in")
		if not is_pick:
			is_pick = true
			PlayerData.add_weapons({"name":"mage", "selected": false})
	else:
		$Label.text = "У вас нет руны"
		$AnimationPlayer.play("fade_in")


func _on_AnimationPlayer_animation_finished(anim_name):
	PlayerData.rune = false
	is_pick = false
