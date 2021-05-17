extends Position2D

func _ready():
	var gold = preload("res://src/Objects/Gold.tscn")
	for i in range(10):
		var gold_inst = gold.instance()
		gold_inst.curent = 1000
		gold_inst.position = global_position + (Vector2(20, 0) * i)
		get_parent().call_deferred("add_child", gold_inst)
