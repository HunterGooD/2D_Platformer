extends MarginContainer

onready var hp_bar = $TextureProgress

func _ready():
	hp_bar.max_value = get_parent().hp
	get_parent().connect("update_hp", self, "update_hp")

func update_hp() -> void:
	hp_bar.value = get_parent().hp
#15 - 100
#10 - x 
