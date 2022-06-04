extends KinematicBody2D
var speed = 75

func _physics_process(delta):
	position += transform.x * speed * delta
