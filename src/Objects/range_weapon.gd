extends Area2D
class_name RangeWeapon

export var damage = 10

var speed = 300
export var direction = -1
var velocity = Vector2()

func _ready():
	$VisibleObject.connect("screen_exited", self, "_exit_screen")
	self.connect("body_entered", self, "_collision")

func _physics_process(delta):
	velocity.x = speed * delta * direction
	if direction == 1:
		$Ammo.flip_h = true 
	translate(velocity)

func _exit_screen():
	queue_free()

func _collision(body):
	if body.get("name") == "TileMap":
		queue_free()
	elif body.get("name") == "Player":
		PlayerData.hp -= damage
		queue_free()
