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

func rotation(a):
	var body_pos = $Body/CollisionShape2D.position.x
	var col_pos = $CollisionShape2D.position.x
	.rotation(a)
	if a == 0:
		$Body/AnimatedSprite.position.x = 20
		$Body/CollisionShape2D.position.x = body_pos
		$CollisionShape2D.position.x = col_pos
	elif a == 1:
		$Body/AnimatedSprite.position.x = 0
		$Body/CollisionShape2D.position.x = body_pos
		$CollisionShape2D.position.x = col_pos
