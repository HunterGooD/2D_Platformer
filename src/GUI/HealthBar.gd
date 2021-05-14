extends HBoxContainer

onready var hp_bar = $TextureProgress
onready var hp_count = $MarginContainer/Background/Number

func _ready():
	hp_bar.value = PlayerData.hp
	hp_count.text = str(PlayerData.hp)
	PlayerData.connect("hp_updated", self, "update_hp")

func update_hp() -> void:
	hp_bar.value = PlayerData.hp
	hp_count.text = str(PlayerData.hp)
