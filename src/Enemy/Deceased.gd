extends "res://RangeEnemy.gd"

func _init():
	ammo = preload("res://src/Objects/Bal.tscn")

func _ready():
	var gold = load("res://src/Objects/Gold.tscn") 
	var gold_inst = gold.instance()
	gold_inst.curent = 100
	gold_inst.position = position + Vector2(40, 0)
	var rune = load("res://src/Objects/Rune.tscn")
	var rune_inst = rune.instance()
	rune_inst.position = position + Vector2(60, 0)
	treasures = [gold_inst, rune_inst]

