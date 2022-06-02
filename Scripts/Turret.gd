extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var sprite = $TurretSprite

func _ready():
	sprite.play("default") # Replace with function body.

func _process(delta):
	pass#if $CollisionShape2D
