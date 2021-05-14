extends "res://src/Player/Actor.gd"

signal update_hp

export var hp = 15
export var damage = 10
var speed: = 200

var is_died = false
var timer_atack = null
var is_atack = false

onready var position_start = position 

func _ready():
	var bar = preload("res://src/GUI/EnemyBar.tscn")
	var new_bar = bar.instance()
	self.add_child(new_bar)
	new_bar.rect_position.x += $CollisionShape2D.position.x -20
	new_bar.rect_position.y -= $CollisionShape2D.position.y + 15
	
	$Body/AnimatedSprite.connect("animation_finished", self, "_finish_animation")
	$Body/AnimatedSprite.connect("frame_changed", self, "_frame_changed")
	$Atack.connect("body_entered", self, "_atack_player")

func _init():	
	timer_atack = Timer.new()
	add_child(timer_atack)
	timer_atack.wait_time = 0.3
	timer_atack.connect("timeout", self, "_atack")

func _physics_process(delta):
	
	if not is_atack and not is_died:
		if not $RayCast2D2.is_colliding() and not $RayCast2D.is_colliding():
			$Body/AnimatedSprite.animation = "idle"
			velocity.x = 0
		
		if $RayCast2D.is_colliding():
			if $RayCast2D.get_collider().get("name") == "Player":
				var positionPlayer = $RayCast2D.get_collider().get("position")
				if positionPlayer.x+30 < position.x:
					velocity.x = -speed
					$Atack/AtackCollision.set_deferred("disabled", true)
					rotation(1)
					$Body/AnimatedSprite.animation = "walk"
				else:
					is_atack = true
					velocity.x = 0
					$Body/AnimatedSprite.animation = "atack"
					timer_atack.start()
			else:
				velocity.x = 0
		
		if $RayCast2D2.is_colliding():
			if $RayCast2D2.get_collider().get("name") == "Player":
				var positionPlayer = $RayCast2D2.get_collider().get("position")
				if positionPlayer.x-30 > position.x:
					velocity.x = speed
					$Atack/AtackCollision.set_deferred("disabled", true)
					rotation(0)
					$Body/AnimatedSprite.animation = "walk"
				else:
					is_atack = true
					velocity.x = 0
					$Body/AnimatedSprite.animation = "atack"
					timer_atack.start()
			else:
				velocity.x = 0

func _atack():
	is_atack = false

func _finish_animation():
	if $Body/AnimatedSprite.animation == "atack":
		$Body/AnimatedSprite.frame = 0
		$Body/AnimatedSprite.animation ="idle"

func _frame_changed():
	if $Body/AnimatedSprite.animation == "atack":
		if $Body/AnimatedSprite.frame == 3:
			$Atack/AtackCollision.set_deferred("disabled", false)


func _atack_player(body):
	PlayerData.hp -= damage


func rotation(a: int) -> void:
	if a == 0:
		$Body/AnimatedSprite.flip_h = true
		$CollisionShape2D.position.x = -abs($CollisionShape2D.position.x)
		$Body/CollisionShape2D.position.x = -abs($Body/CollisionShape2D.position.x)
		$Atack/AtackCollision.position.x = abs($Atack/AtackCollision.position.x)
	elif a == 1:
		$Body/AnimatedSprite.flip_h = false
		$CollisionShape2D.position.x = abs($CollisionShape2D.position.x)
		$Body/CollisionShape2D.position.x = abs($Body/CollisionShape2D.position.x)
		$Atack/AtackCollision.position.x = -abs($Atack/AtackCollision.position.x)


func hurt(dmg:int) -> void:
	velocity.x = 0
	if (hp - dmg) < 0 and not is_died:
		$Body/AnimatedSprite.animation = "death"
		hp = 0
		is_died = true
	elif not is_died:
		$Body/AnimatedSprite.animation = "hurt"
		hp -= dmg
	emit_signal("update_hp")
















