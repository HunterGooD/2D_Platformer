extends "res://src/Player/Actor.gd"

const Enemy = preload("res://src/Enemy/Enemy.gd")

export var speed: = 300
export var jump: = 1000
export var dmg = 10

var timer = null
var direction = 1
var iter = 0

var is_crouch = false
var is_atack = false
var is_dead = false
var is_cast = false
var is_hurt = false

func _init():
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 0.6
	timer.connect("timeout", self, "_timeout")
	
func _ready():
	PlayerData.connect("hp_updated", self, "update_hp")

func _input(event):
	if event.as_text() in ["1", "2", "3"] and not is_dead:
		PlayerData.update_weapon(int(event.as_text()))

func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("reload"):
		PlayerData.reset()
		get_tree().reload_current_scene()
	
	if not is_dead:			
		if Input.is_action_just_released("player_atack_light") and PlayerData.selected_weapon() == "mage" and is_cast:
			$AnimatedSprite.frame = 0
			$AnimatedSprite.animation ="idle"
			is_cast = false
			is_atack = false
		
		if Input.is_action_pressed("player_atack_light") and is_on_floor() and !is_atack:
			play_atack()
	
	if not is_atack and not is_dead:
		if Input.is_action_just_pressed("player_couth") and is_on_floor():
			if $AnimatedSprite.animation == "run":
				is_crouch = true
				$AnimatedSprite.animation = "slide"
				slide_collision()
			#else:
			#is_crouch = true
			#$AnimatedSprite.animation = "crouch"
		
		if Input.is_action_pressed("player_left"):
			direction = -1
			velocity.x = -speed
			$AnimatedSprite.flip_h = true
			$AnimatedSprite/Atack/AtackCollision.position.x = -abs($AnimatedSprite/Atack/AtackCollision.position.x)
			$AnimatedSprite/Atack/AtackCollision.set_deferred("disabled", true)
			play_aRun()
		elif Input.is_action_pressed("player_right"):
			direction = 1
			velocity.x = speed
			$AnimatedSprite.flip_h = false
			$AnimatedSprite/Atack/AtackCollision.position.x = abs($AnimatedSprite/Atack/AtackCollision.position.x)
			$AnimatedSprite/Atack/AtackCollision.set_deferred("disabled", true)
			play_aRun()
		else:
			velocity.x = 0
			if is_on_floor() and not is_crouch and not is_hurt:
				$AnimatedSprite.animation ="idle"
		
		if Input.is_action_pressed("player_jump") and is_on_floor() and not is_crouch:
			$AnimatedSprite/Atack/AtackCollision.set_deferred("disabled", true)
			is_crouch = false
			$AnimatedSprite.animation = "jump"
			
			velocity.y = -jump
			
		if not is_on_floor():
			if $AnimatedSprite.animation != "jump" and not is_crouch:
				$AnimatedSprite.animation = "fall"
			
	
	position.x = clamp(position.x, 12, 100000)

func play_aRun():
	if is_on_floor() and not is_crouch:
		$AnimatedSprite.animation = "run"


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "jump":
		$AnimatedSprite.animation = "fall"
	elif $AnimatedSprite.animation == "atack":
		$AnimatedSprite.frame = 0
		$AnimatedSprite.animation ="idle"
	elif $AnimatedSprite.animation == "bow":
		$AnimatedSprite.frame = 0
		$AnimatedSprite.animation ="idle"
	elif $AnimatedSprite.animation == "cast":
		$AnimatedSprite.animation ="cast_loop"
	elif $AnimatedSprite.animation == "slide":
		is_crouch = false
		slide_collision()
	elif $AnimatedSprite.animation == "hurt":
		is_hurt = false

func _timeout():
	$AnimatedSprite/Atack/AtackCollision.set_deferred("disabled", true)
	timer.stop()
	is_atack = false


func update_hp():
	if PlayerData.hp == 0:
		is_dead = true
		velocity.x = 0
		$AnimatedSprite.animation = "die"
	else:
		is_hurt = true
		$AnimatedSprite.animation = "hurt"


func _on_AnimatedSprite_frame_changed():
	if $AnimatedSprite.animation == "atack":
		if $AnimatedSprite.frame == 2:
			$AnimatedSprite/Atack/AtackCollision.set_deferred("disabled", false)
	if $AnimatedSprite.animation == "bow":
		if $AnimatedSprite.frame == 7:
			var arrow = load("res://src/Objects/Arrow.tscn")
			var arrow_inst = arrow.instance()
			arrow_inst.direction = direction
			arrow_inst.position = $Position2D.global_position
			get_parent().add_child(arrow_inst)
	if $AnimatedSprite.animation == "cast_loop":
		if $AnimatedSprite.frame == 3:
			#if iter != 1:
			#	iter += 1
			#else:
			_cast_end()
			

func _on_Atack_body_entered(body):
	if body is Enemy or body.name == "ArcaneArcher":
		body.hurt(dmg)

func _cast_end():
	if is_cast:
		var waveform = load("res://src/Objects/Waveform.tscn")
		var w_inst = waveform.instance()
		w_inst.position = $Position2D2.global_position
		w_inst.direction = direction
		w_inst.damage = 20
		get_parent().add_child(w_inst)
		is_cast = false
		is_atack = false
		iter = 0

func play_atack():
	velocity.x = 0
	is_atack = true
	if PlayerData.selected_weapon() == "sword":
		$AnimatedSprite.animation = "atack"
		timer.start()
	elif PlayerData.selected_weapon() == "bow":
		$AnimatedSprite.animation = "bow"
		timer.start()
	elif PlayerData.selected_weapon() == "mage" and not is_cast:
		is_cast = true
		$AnimatedSprite.animation = "cast"
		timer.start()

func slide_collision():
	$SlideCollision.set_deferred("disabled", not is_crouch)
	$CollisionShape2D.set_deferred("disabled",  is_crouch)
