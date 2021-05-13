extends Node

signal score_updated

export var score: = 0 setget set_score


func set_score(val:int) -> void:
	score = val
	print(score)
	emit_signal("score_updated")
