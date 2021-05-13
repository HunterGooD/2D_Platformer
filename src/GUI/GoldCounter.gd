extends MarginContainer

onready var score = $Background/Number

func _ready():
	PlayerData.connect("score_updated", self, "update_score")

func update_score() -> void:
	score.text = str(PlayerData.score)
