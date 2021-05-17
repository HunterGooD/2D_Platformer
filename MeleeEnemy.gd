extends "res://src/Enemy/Enemy.gd"

func _ready():
	$Body/AnimatedSprite.connect("animation_finished", self, "_finish_animation")
	$Body/AnimatedSprite.connect("frame_changed", self, "_frame_changed")
	$Atack.connect("body_entered", self, "_atack_player")


func _finish_animation():
	if $Body/AnimatedSprite.animation == "atack":
		$Atack/AtackCollision.set_deferred("disabled", true)
		$Body/AnimatedSprite.frame = 0
		$Body/AnimatedSprite.animation ="idle"

func _frame_changed():
	if $Body/AnimatedSprite.animation == "atack":
		if $Body/AnimatedSprite.frame == 3:
			$Atack/AtackCollision.set_deferred("disabled", false)

func _atack_player(body):
	PlayerData.hp -= damage

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

func hurt(dmg:int) -> void:
	$Atack/AtackCollision.set_deferred("disabled", true)
	.hurt(dmg)

func rotation(a: int) -> void:
	if a == 0:
		$Atack/AtackCollision.position.x = abs($Atack/AtackCollision.position.x)
	elif a == 1:
		$Atack/AtackCollision.position.x = -abs($Atack/AtackCollision.position.x)
	.rotation(a)
