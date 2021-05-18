extends Area2D

var is_pick = false

func _on_Rune_body_entered(body):
	if not is_pick:
		$AnimationPlayer.play("fade_in")
		is_pick = true
		PlayerData.rune = true


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
