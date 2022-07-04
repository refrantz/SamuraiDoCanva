extends Node2D

onready var cam = $Camera2D
onready var actor = $Player
onready var sceneLimit = $SceneLimit
onready var winLimit = $bannerWin/WinArea/WinLimit

func _physics_process(_delta):
	cam.position.x = actor.position.x-365
	cam.position.y = actor.position.y-200
	
	if actor.position.y > sceneLimit.position.y:
		get_tree().change_scene("res://Scenes/Menu.tscn")
	#if actor.position.y == winLimit.position.y and actor.position.x == winLimit.position.x:
	#	print("Win")
	#	get_tree().change_scene("res://Scenes/Menu.tscn")
	pass
