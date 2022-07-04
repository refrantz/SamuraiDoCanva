extends Node2D

onready var cam = $Camera2D
onready var actor = $Player
onready var sceneLimit = $SceneLimit
onready var winLimit = $bannerWin/WinArea/WinLimit

func _physics_process(_delta):
	cam.position.x = actor.position.x-365
	cam.position.y = actor.position.y-300
	
