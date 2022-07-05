extends KinematicBody2D

onready var player
onready var animsprite = $AnimatedSprite
onready var sprite = $AnimatedSprite/AnimationPlayer
onready var collision = $CollisionShape2D
var max_health = 10
var health = max_health
var inArea = false
var dead = false
var aggro = false
var velocity = 0
var lastflip = false
var initVel = -50

func _physics_process(delta):
	position.x += delta*velocity
	flip_h(velocity < 0 or lastflip)
		
	if(velocity > 0):
		lastflip = false

func _ready():
	velocity = 0
	sprite.play("idle")
	health = max_health
	$HpBar.set_percent_value_int(health)

func hit(damage):
	if(!sprite.current_animation == "attack"):
		velocity = 0
		sprite.play("dash")
		if(player.lastflip):
			velocity = -50
			initVel = velocity
			self.position.x = player.position.x + 50
		else:
			velocity = 50
			initVel = velocity
			self.position.x = player.position.x - 50
	else:
		velocity = 0
		sprite.play("hurt")
		health -= damage
		$HpBar.set_percent_value_int(health)

func _on_AnimationPlayer_animation_finished(anim_name):
	if(dead):
		get_tree().change_scene("res://Scenes/Menu.tscn")
	
	if(health <= 0 and !dead):
		dead = true
		sprite.play("death")
		velocity = 0
	if(!dead):
		if(aggro):
			velocity = 0
			sprite.play("attack")
		else:
			sprite.play("run")
			velocity = initVel

func _on_Area2DVision_body_entered(body):
	player = body
	if(body.is_in_group("player") and !dead):
		inArea = true
		
func _on_Area2DVision_body_exited(body):
	if(body.is_in_group("player") and !dead):
		velocity = 0
		inArea = false

func _on_Area2DRange_body_entered(body):
	if(body.is_in_group("player") and !dead):
		sprite.play("attack")
		aggro = true

func _on_Area2DRange_body_exited(body):
	if(body.is_in_group("player") and !dead):
		aggro = false

func _on_Area2DVision2_body_exited(body):
	if(body.is_in_group("floor") and sprite.current_animation == "run"):
		initVel = -initVel
		velocity = initVel
		
	
func flip_h(flip:bool):
	var x_axis = global_transform.x
	global_transform.x.x = (-1 if flip else 1) * abs(x_axis.x)
	if flip:
		lastflip = true
	else:
		lastflip = false
