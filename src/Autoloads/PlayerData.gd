extends Node

signal score_updated
signal hp_updated
signal add_weapons
signal update_weapon

var score: = 0 setget set_score
var hp: = 40 setget set_hp
onready var gui_view = preload("res://src/GUI/Weapons.tscn")

var rune = false
var weapons = [
	{
		"name": "sword",
		"selected": true,
	}
]

func set_score(val:int) -> void:
	score = val
	emit_signal("score_updated")

func set_hp(val:int) -> void:
	if val < 0:
		val = 0
	elif val > 100:
		val = 100
	hp = val
	emit_signal("hp_updated")

func reset() -> void:
	score = 0
	hp = 40

func add_weapons(a):
	weapons.append(a)
	emit_signal("add_weapons")

func update_weapon(idx):
	if idx > len(weapons):
		return
	for i in range(len(weapons)):
		if i == (idx -1):
			weapons[i]["selected"] = true
		else:
			weapons[i]["selected"] = false
	emit_signal("update_weapon")

func selected_weapon() -> String:
	for w in weapons:
		if w["selected"]:
			return w["name"]
	return ""
	

