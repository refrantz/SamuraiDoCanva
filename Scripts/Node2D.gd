extends Node2D

onready var cam = $Camera2D
onready var actor = $Player

func _physics_process(_delta):
	cam.position.x = actor.position.x-370
	cam.position.y = actor.position.y-220
