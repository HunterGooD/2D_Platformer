extends Area2D

var next_to_player = false

func _physics_process(delta):
	if Input.is_action_pressed("use") and next_to_player:
		PlayerData.hp += 10
		queue_free()

func _on_MedicalKit_body_entered(body):
	$AnimationPlayer.play("fade_in")
	next_to_player = true


func _on_MedicalKit_body_exited(body):
	$AnimationPlayer.play("fade_out")
	next_to_player = false
