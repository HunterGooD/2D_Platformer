extends Area2D

onready var anim_pl = $AnimationPlayer
var is_pick = false

func _on_Bow_body_entered(body):
	anim_pl.play("pickable")
	if not is_pick:
		is_pick = true
		PlayerData.add_weapons({"name": "bow", "selected": false})
	


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
