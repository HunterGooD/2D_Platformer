extends Area2D

onready var helper = preload("res://src/GUI/Helper.tscn")
var next_to_player = false

func _ready():
	var helper_inst = helper.instance()
	add_child(helper_inst)
	move_child(helper_inst, 0)
	connect("body_entered", self, "_on_object_body_entered")
	connect("body_exited", self, "_on_object_body_exited")

func _physics_process(delta):
	handl_input()
		
func handl_input():
	if Input.is_action_just_pressed("use") and next_to_player:
		action()
		queue_free()

func action():
	pass
	
func _on_object_body_entered(body):
	$Helper/AnimationPlayer.play("fade_in")
	next_to_player = true


func _on_object_body_exited(body):
	$Helper/AnimationPlayer.play("fade_out")
	next_to_player = false
