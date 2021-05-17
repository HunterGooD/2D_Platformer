extends "res://src/Player/Actor.gd"
class_name Enemy 

signal update_hp

export var hp = 15
export var damage = 10
export var speed: = 200
export var wait_time = 0.1
export var is_treasure = true
export var treasures = [] # Objects treasure gold and other

var is_died = false
var timer_atack = null
var is_atack = false

onready var position_start = position 

func _init():	
	timer_atack = Timer.new()
	add_child(timer_atack)
	timer_atack.wait_time = 0.1
	timer_atack.connect("timeout", self, "_atack")

func _ready():
	var bar = preload("res://src/GUI/EnemyBar.tscn")
	var new_bar = bar.instance()
	self.add_child(new_bar)
	new_bar.rect_position.x += $CollisionShape2D.position.x -20
	new_bar.rect_position.y -= $CollisionShape2D.position.y + 15

func _atack():
	is_atack = false

func rotation(a: int) -> void:
	if a == 0:
		$Body/AnimatedSprite.flip_h = true
		$CollisionShape2D.position.x = -abs($CollisionShape2D.position.x)
		$Body/CollisionShape2D.position.x = -abs($Body/CollisionShape2D.position.x)
	elif a == 1:
		$Body/AnimatedSprite.flip_h = false
		$CollisionShape2D.position.x = abs($CollisionShape2D.position.x)
		$Body/CollisionShape2D.position.x = abs($Body/CollisionShape2D.position.x)


func hurt(dmg:int) -> void:
	velocity.x = 0
	is_atack = false
	if (hp - dmg) <= 0 and not is_died:
		$Body/AnimatedSprite.animation = "death"
		hp = 0
		is_died = true
		if len(treasures) == 0 and is_treasure:
			var gold = preload("res://src/Objects/Gold.tscn")
			var gold_inst = gold.instance()
			gold_inst.curent = 10
			gold_inst.position = position + Vector2(40, 0)
			get_parent().add_child(gold_inst)
		elif is_treasure and len(treasures) != 0:
			#TODO: drop treasure from array 
			for treasure in treasures:
				print(treasure)
	elif not is_died:
		$Body/AnimatedSprite.animation = "hurt"
		hp -= dmg
	emit_signal("update_hp")













