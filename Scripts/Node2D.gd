extends Node2D

onready var cam = $Camera2D
onready var actor = $Player
onready var sceneLimit = $SceneLimit

func _physics_process(_delta):
	cam.position.x = actor.position.x-365
	cam.position.y = actor.position.y-200
	
	if actor.position.y > sceneLimit.position.y:
		get_tree().change_scene("res://Scenes/Menu.tscn")
	pass
