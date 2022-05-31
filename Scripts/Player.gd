extends KinematicBody2D

const GRAVITY = 1600.0
const JUMP_SPEED = -550
const WALK_SPEED = 400

var jumping = false
var velocity = Vector2()
onready var sprite := $PlayerSprite

func get_input():
	velocity.x = Input.get_action_strength("right")-Input.get_action_strength("left")
	var jump = Input.is_action_just_pressed('up')
	#velocity.y = Input.get_action_strength("down")-Input.get_action_strength("up")
	
	velocity.x *= WALK_SPEED
	
	if Input.is_action_just_pressed("attack"):
		sprite.play("attack")	
	elif Input.is_action_just_pressed("defense"):
		sprite.play("defense")
	
	#sprite.play("idle")
		
	if jump and is_on_floor():
		jumping = true
		velocity.y = JUMP_SPEED
		

func _physics_process(delta):
	get_input()
	velocity.y += GRAVITY * delta
	
	if jumping and is_on_floor():
		jumping = false
	
	velocity = move_and_slide(velocity, Vector2(0, -1))
