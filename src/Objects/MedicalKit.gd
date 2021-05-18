extends "res://src/Objects/UsingObjects.gd"

export var heal_power = 10

func action():
	PlayerData.hp += heal_power
