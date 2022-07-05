extends KinematicBody2D

var health = 3
onready var animsprite = $AnimatedSprite
onready var sprite = $AnimatedSprite/AnimationPlayer
onready var collision = $CollisionShape2D
var inArea = false
var dead = false
var aggro = false
var velocity = 0
var lastflip = true
var initVel = -50

func _physics_process(delta):
	position.x += delta*velocity
	flip_h(velocity < 0 or lastflip)
		
	if(velocity > 0):
		lastflip = false

func _ready():
	velocity = 0
	sprite.play("idle")

func hit(damage):
	velocity = 0
	sprite.play("hurt")
	health -= damage

func _on_AnimationPlayer_animation_finished(anim_name):
	if(dead):
		self.remove_child(animsprite)
		self.remove_child(collision)
	
	if(health <= 0 and !dead):
		dead = true
		sprite.play("death")
		velocity = 0
	if(!dead):
		if(inArea):
			if(aggro):
				sprite.play("attack")
		if(!inArea):
			sprite.play("run")
			velocity = initVel

func _on_Area2DVision_body_entered(body):
	if(body.is_in_group("player") and !dead):
		velocity = 0
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
	initVel = -initVel
	velocity = initVel
	
	
func flip_h(flip:bool):
	var x_axis = global_transform.x
	global_transform.x.x = (-1 if flip else 1) * abs(x_axis.x)
	if flip:
		lastflip = true
	else:
		lastflip = false
