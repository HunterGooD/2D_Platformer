extends KinematicBody2D

signal update_hp

onready var sf = $AnimatedSprite.get_sprite_frames()

export var hp = 100
export var damage = 10
export var speed: = 200
export var treasures = []

var gravity:float = 2000.0
var velocity: = Vector2.ZERO
var FLOOR = Vector2(0,-1)
var timer_atack = null
var timer_wait = null
var frames = 0

var special = false
var is_atack = false
var is_died = false

func _init():
	timer_atack = Timer.new()
	add_child(timer_atack)
	timer_atack.wait_time = 2
	timer_atack.one_shot = true
	timer_atack.connect("timeout", self, "_timeout")
	
	timer_wait = Timer.new()
	add_child(timer_wait)
	timer_wait.wait_time = 3
	timer_wait.connect("timeout", self, "_not_atack")

func _ready():
	randomize()
	var bar = preload("res://src/GUI/EnemyBar.tscn")
	var new_bar = bar.instance()
	self.add_child(new_bar)
	new_bar.rect_position.x += $CollisionShape2D.position.x -20
	new_bar.rect_position.y -= $CollisionShape2D.position.y + 30

func _physics_process(delta):
	var pl = get_parent().get_parent().get_player()
	if position.distance_to(pl.position) <= 1100 and not is_died:
		if position.x - pl.position.x <= 0:
			$AnimatedSprite.flip_h = false
			$Position2D.position.x = abs($Position2D.position.x)
		else:
			$AnimatedSprite.flip_h = true
			$Position2D.position.x = -abs($Position2D.position.x)
			
		if timer_atack.is_stopped():
			timer_atack.start()
			if timer_wait.is_stopped():
				timer_wait.start()

		gravity(delta)
		
	if not is_atack and not is_died:
		$AnimatedSprite.animation = "idle"	
	
func _timeout():
	is_atack = true

func _not_atack():
	if is_atack:
		rand_atack()

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "atack":
		if special and frames != 2:
			frames += 1
			$AnimatedSprite.frame = 0
		else:			
			is_atack = false
			frames = 0
			special = false


func _on_AnimatedSprite_frame_changed():
	if $AnimatedSprite.animation == "atack":
		if $AnimatedSprite.frame == 7:
			$Position2D.global_position

func rand_atack():
	print(randi()%2)
	if randi()%2:
		atack()
	else:
		special = true
		special_atack()

func gravity(delta):
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, FLOOR)

func special_atack():
	sf.set_animation_speed("atack", 15)
	$AnimatedSprite.animation = "atack"

func atack():
	sf.set_animation_speed("atack", 8)
	$AnimatedSprite.animation = "atack"

func hurt(dmg:int) -> void:
	velocity.x = 0
	is_atack = false
	if (hp - dmg) <= 0 and not is_died:
		$AnimatedSprite.animation = "death"
		hp = 0
		is_died = true
		for treasure in treasures:
			get_parent().call_deferred("add_child", treasure)
	elif not is_died:
		hp -= dmg
	emit_signal("update_hp")
