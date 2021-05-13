extends KinematicBody2D

export var speed: = 300
export var gravity:float = 2000.0
export var jump: = 1000

var timer = null
var velocity: = Vector2.ZERO
var FLOOR = Vector2(0,-1)
var is_crouch = false
var is_atack = false
func _init():
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 0.8
	timer.connect("timeout", self, "_timeout")
	
	
func _physics_process(delta: float) -> void:
	
	if Input.is_action_pressed("player_atack_light") and is_on_floor() and !is_atack:
		$AnimatedSprite.animation = "atack"
		timer.start()
		
		is_atack = true
	
	if not is_atack:
		if Input.is_action_just_pressed("player_couth") and is_on_floor():
			is_crouch = true
			$AnimatedSprite.animation = "crouch"
		
		if Input.is_action_pressed("player_left"):
			velocity.x = -speed
			$AnimatedSprite.flip_h = true
			play_aRun()
		elif Input.is_action_pressed("player_right"):
			velocity.x = speed
			$AnimatedSprite.flip_h = false
			play_aRun()
		else:
			velocity.x = 0
			if is_on_floor() and not is_crouch:
				$AnimatedSprite.animation ="idle"
		
			
		velocity.y += gravity * delta
		
		if Input.is_action_pressed("player_jump") and is_on_floor():
			is_crouch = false
			$AnimatedSprite.animation = "jump"
			
			velocity.y = -jump
			
		if not is_on_floor():
			if $AnimatedSprite.animation != "jump":
				$AnimatedSprite.animation = "fall"
			
		velocity = move_and_slide(velocity, FLOOR)
	
	position.x = clamp(position.x, 12, 100000)

func play_aRun():
	if is_on_floor() and not is_crouch:
		$AnimatedSprite.animation = "run"


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "jump":
		$AnimatedSprite.animation = "fall"
	elif $AnimatedSprite.animation == "atack":
		$AnimatedSprite.animation ="idle"

func _timeout():
	timer.stop()
	is_atack = false







