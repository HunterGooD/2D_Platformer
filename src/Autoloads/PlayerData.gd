extends Node

signal score_updated
signal hp_updated

var score: = 0 setget set_score
var hp: = 40 setget set_hp

func set_score(val:int) -> void:
	score = val
	emit_signal("score_updated")

func set_hp(val:int) -> void:
	if val < 0:
		val = 0
	hp = val
	emit_signal("hp_updated")
