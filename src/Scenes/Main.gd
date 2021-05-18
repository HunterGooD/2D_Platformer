extends Node2D

func _ready():
	PlayerData.connect("update_weapon", self, "_update_weapons")
	PlayerData.connect("add_weapons", self, "_add_weapons")
	_add_weapons()


func _add_weapons():
	var index = 1
	var children = $GUI/Weapons.get_children()
	for weap in PlayerData.weapons:
		var flag = false
		for c in children:
			if c.name == weap["name"]:
				flag = true
				break
		if flag:
			index += 1
			continue
		var w_inst = PlayerData.gui_view.instance()
		w_inst.name = weap["name"]
		w_inst.get_child(0).get_child(0).animation = weap["name"]
		w_inst.get_child(0).get_child(1).text = str(index)
		index += 1
		if weap["selected"]:
			w_inst.get_child(0).self_modulate = Color(255,0,0, 0.01)
		$GUI/Weapons.add_child(w_inst)

func _update_weapons():
	var children = $GUI/Weapons.get_children()
	for weap in PlayerData.weapons:
		for c in children:
			if c.name == weap["name"] and weap["selected"]:
				c.get_child(0).self_modulate = Color(255,0,0, 0.01)
			elif c.name == weap["name"] and not weap["selected"]:
				c.get_child(0).self_modulate = Color(255,255,255,0)
