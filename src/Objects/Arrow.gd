extends "res://src/Objects/range_weapon.gd"

func _physics_process(delta):
	velocity.x = speed * delta * direction
	if direction == 1:
		$Ammo.flip_h = true 
		$Ammo.rotation_degrees = abs($Ammo.rotation_degrees)
	translate(velocity)

func _collision(body):
	var Enemy = load("res://src/Enemy/Enemy.gd")
	if body.get("name") == "TileMap":
		queue_free()
	elif body is Enemy:
		body.hurt(damage)
