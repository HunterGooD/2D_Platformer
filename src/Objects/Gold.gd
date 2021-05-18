extends Area2D

export var curent = 1

var is_pick = false

onready var anim_pl = $AnimationPlayer


func _on_Gold_body_entered(body):
	if not is_pick:
		anim_pl.play("fade")
		PlayerData.score += curent
	is_pick = true


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
