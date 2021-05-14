extends "res://src/Player/Actor.gd"

export var speed: = 300
export var jump: = 1000
export var dmg = 10

var timer = null

var is_crouch = false
var is_atack = false
var is_dead = false

func _init():
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 0.6
	timer.connect("timeout", self, "_timeout")
	
func _ready():
	PlayerData.connect("hp_updated", self, "update_hp")

func _physics_process(delta: float) -> void:
	if not is_dead:
			
		if Input.is_action_pressed("player_atack_light") and is_on_floor() and !is_atack:
			$AnimatedSprite.animation = "atack"
			velocity.x = 0
			timer.start()
			
			is_atack = true
	
	if not is_atack and not is_dead:
		if Input.is_action_just_pressed("player_couth") and is_on_floor():
			is_crouch = true
			$AnimatedSprite.animation = "crouch"
		
		if Input.is_action_pressed("player_left"):
			velocity.x = -speed
			$AnimatedSprite.flip_h = true
			$Atack/AtackCollision.position.x = -abs($Atack/AtackCollision.position.x)
			$Atack/AtackCollision.set_deferred("disabled", true)
			play_aRun()
		elif Input.is_action_pressed("player_right"):
			velocity.x = speed
			$AnimatedSprite.flip_h = false
			$Atack/AtackCollision.position.x = abs($Atack/AtackCollision.position.x)
			$Atack/AtackCollision.set_deferred("disabled", true)
			play_aRun()
		else:
			velocity.x = 0
			if is_on_floor() and not is_crouch:
				$AnimatedSprite.animation ="idle"
		
		if Input.is_action_pressed("player_jump") and is_on_floor():
			$Atack/AtackCollision.set_deferred("disabled", false)
			is_crouch = false
			$AnimatedSprite.animation = "jump"
			
			velocity.y = -jump
			
		if not is_on_floor():
			if $AnimatedSprite.animation != "jump":
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

func _timeout():
	$Atack/AtackCollision.set_deferred("disabled", true)
	timer.stop()
	is_atack = false


func update_hp():
	if PlayerData.hp == 0:
		is_dead = true
		velocity.x = 0
		$AnimatedSprite.animation = "die"
	else:
		$AnimatedSprite.animation = "hurt"


func _on_AnimatedSprite_frame_changed():
	if $AnimatedSprite.animation == "atack":
		if $AnimatedSprite.frame == 1:
			$Atack/AtackCollision.set_deferred("disabled", false)


func _on_Atack_body_entered(body):
	body.hurt(dmg)

