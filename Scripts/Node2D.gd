extends Node2D

onready var cam = $Camera2D
onready var actor = $Player
onready var sceneLimit = $SceneLimit
onready var winLimit = $bannerWin/WinArea

func _physics_process(_delta):
	cam.position.x = actor.position.x-365
	cam.position.y = actor.position.y-200
	
	if actor.position.y > sceneLimit.position.y:
		get_tree().change_scene("res://Scenes/Menu.tscn")
	pass


func _on_WinArea_body_entered(body):
	print("Win")
	get_tree().change_scene("res://Scenes/levels/Level2.tscn") # Replace with function body.
