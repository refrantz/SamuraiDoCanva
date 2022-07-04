extends KinematicBody2D
var speed = 100
onready var sprite = $AnimatedSprite
var hit = false

func _physics_process(delta):
	position += transform.x * speed * delta


func _on_Area2D_body_entered(body):
	speed = 0
	hit = true
	sprite.play("hit")
	$Area2D.queue_free()

func _on_AnimatedSprite_animation_finished():
	if(hit):
		sprite.queue_free()


func _on_Area2D_area_entered(area):
	if(area.is_in_group("player")):
		speed = 0
		hit = true
		sprite.play("hit")
		$Area2D.queue_free()
