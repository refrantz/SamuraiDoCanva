extends KinematicBody2D

var health = 3
onready var sprite = $AnimatedSprite
onready var collision = $CollisionShape2D
var inArea = false
var dead = false
var charged = false

func _ready():
	sprite.play("idle")

func hit(damage):
	sprite.play("hurt")
	health -= damage
	charged = false

func _on_AnimatedSprite_animation_finished():
			
	if(health <= 0 and !dead):
		dead = true
		sprite.play("death")
		self.remove_child(collision)
		
	if(!dead):
		if(inArea):
			if(!charged):
				sprite.play("charge")
				charged = true
				return
			if(charged):
				sprite.play("shoot")
				charged = false
			
		if(!inArea):
			sprite.play("idle")

func _on_Area2D_body_entered(body):
	if(body.is_in_group("player") and !dead):
		inArea = true
		sprite.play("wake")

func _on_Area2D_body_exited(body):
	if(body.is_in_group("player") and !dead):
		inArea = false
		sprite.play("wake", true)
