extends Area2D

onready var anim_pl = $AnimationPlayer


func _on_Bow_body_entered(body):
	anim_pl.play("pickable")
	


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
