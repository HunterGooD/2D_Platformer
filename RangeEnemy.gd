extends "res://src/Enemy/Enemy.gd"

var ammo
export var time_betwen_shoot = 0.1
var timer_betwen_shoot  

var direction = -1

func _init():
	timer_betwen_shoot = Timer.new()
	add_child(timer_betwen_shoot)
	timer_betwen_shoot.one_shot = true
	timer_betwen_shoot.wait_time = time_betwen_shoot
	timer_betwen_shoot.connect("timeout", self, "_shoot")

func _ready():
	$Body/AnimatedSprite.connect("animation_finished", self, "_finish_animation")
	$Body/AnimatedSprite.connect("frame_changed", self, "_frame_changed")

func _physics_process(delta):
	if not is_atack and not is_died:
		if not $RayCast2D2.is_colliding() and not $RayCast2D.is_colliding():
			$Body/AnimatedSprite.animation = "idle"
			velocity.x = 0
		
		if $RayCast2D.is_colliding():
			if $RayCast2D.get_collider().get("name") == "Player":
				rotation(1)
				direction = -1
				timer_betwen_shoot.start()
		
		if $RayCast2D2.is_colliding():
			if $RayCast2D2.get_collider().get("name") == "Player":
				rotation(0)
				direction = 1
				timer_betwen_shoot.start()
					

func _finish_animation():
	if $Body/AnimatedSprite.animation == "atack":
		is_atack = false
		#$Body/AnimatedSprite.animation = "idle"
	
func _frame_changed():
	if $Body/AnimatedSprite.animation == "atack" and $Body/AnimatedSprite.frame == 2:
		var ammo_inst = ammo.instance()
		ammo_inst.direction = direction
		ammo_inst.position = $Position2D.global_position
		get_parent().add_child(ammo_inst)

func rotation(a: int) -> void:
	var pos = $Position2D.get("position")
	if a == 0:
		$Position2D.set_deferred("position", -abs(pos.x)) 
	elif a == 1:
		$Position2D.set_deferred("position", abs(pos.x)) 
		
	.rotation(a)

func _shoot(): 
	if not is_died:
		is_atack = true
		$Body/AnimatedSprite.animation = "atack"
	


