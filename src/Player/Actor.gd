extends KinematicBody2D
class_name Actor

var gravity:float = 2000.0
var velocity: = Vector2.ZERO
var FLOOR = Vector2(0,-1)

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, FLOOR)

