extends KinematicBody2D

var health = 3
onready var animsprite = $AnimatedSprite
onready var sprite = $AnimatedSprite/AnimationPlayer
onready var collision = $CollisionShape2D
var inArea = false
var dead = false
var charged = false
var aggro = false

func _ready():
	sprite.play("idle")

func hit(damage):
	sprite.play("hurt")
	health -= damage
	charged = false

func _on_AnimationPlayer_animation_finished(anim_name):
	if(dead):
		self.remove_child(animsprite)
		self.remove_child(collision)
	
	if(health <= 0 and !dead):
		dead = true
		sprite.play("death")
		
	if(!dead):
		if(inArea):
			if(!charged):
				sprite.play("charge")
				charged = true
				return
			if(charged and aggro):
				sprite.play("attack")
				charged = false
			
		if(!inArea):
			sprite.play("idle")

func _on_Area2DVision_body_entered(body):
	if(body.is_in_group("player") and !dead):
		sprite.play("transition")
		inArea = true
		
func _on_Area2DVision_body_exited(body):
	if(body.is_in_group("player") and !dead):
		sprite.play("transition", true)
		charged = false
		inArea = false

func _on_Area2DRange_body_entered(body):
	if(body.is_in_group("player") and !dead):
		sprite.play("attack")
		charged = false
		aggro = true
		print("agroo")

func _on_Area2DRange_body_exited(body):
	if(body.is_in_group("player") and !dead):
		aggro = false
