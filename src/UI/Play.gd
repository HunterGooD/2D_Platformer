extends TextureButton

func _on_Play_button_up():
	get_tree().change_scene("res://src/UI/SelectedPlayer.tscn")
