extends Area2D

export var curent = 1

onready var anim_pl = $AnimationPlayer


func _on_Gold_body_entered(body):
	anim_pl.play("fade")
	PlayerData.score += curent


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
