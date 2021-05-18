extends "res://src/Objects/range_weapon.gd"

func _collision(body):
	var Enemy = load("res://src/Enemy/Enemy.gd")
	if body.get("name") == "TileMap":
		queue_free()
	elif body is Enemy:
		body.hurt(damage)
