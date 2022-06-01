extends KinematicBody2D

const GRAVITY = 1600.0
const JUMP_SPEED = -550
const WALK_SPEED = 400

var jumping = false
var velocity = Vector2()
onready var sprite := $PlayerSprite
var state_machine


func _ready():
	state_machine = $AnimationTree.get("parameters/playback")

func get_input():
	velocity.x = Input.get_action_strength("right")-Input.get_action_strength("left")
	var jump = Input.is_action_just_pressed('up')
	
	if(velocity.x != 0 and velocity.y == 0):
		state_machine.travel("run")
	
	if(velocity.x > 0):
		sprite.scale.x = 0.6
	elif(velocity.x < 0):
		sprite.scale.x = -0.6
		
	if(velocity.x == 0 and velocity.y == 0):
		state_machine.travel("idle")
		
	if(Input.is_action_just_pressed("dash")):
		state_machine.travel("dash")
	
	if(Input.is_action_pressed("block")):
		state_machine.travel("block")
		
	if(is_on_floor() and Input.is_action_pressed("attack")):
		state_machine.travel("heavy_attack")
		
	if(Input.is_action_just_pressed("attack")):
		if(is_on_floor()):
			state_machine.travel("attack1")
		else:
			state_machine.travel("jump_attack1")
	
	if !is_on_floor() and Input.is_action_just_pressed('up'):
		state_machine.travel("jump_flip")
	
	velocity.x *= WALK_SPEED
	
	#sprite.play("idle")
		
	if jump and is_on_floor():
		state_machine.travel("jump")
		jumping = true
		velocity.y = JUMP_SPEED
		
	
		
func hurt():
	state_machine.travel("knockback")
func death():
	state_machine.travel("death")
	

func _physics_process(delta):
	get_input()
	velocity.y += GRAVITY * delta
	
	if jumping and is_on_floor():
		jumping = false
	
	velocity = move_and_slide(velocity, Vector2(0, -1))
