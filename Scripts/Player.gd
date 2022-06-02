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
	
		
	if(velocity.x == 0 and velocity.y == 0  and state_machine.get_current_node() != "attack1" and state_machine.get_current_node() != "attack2"):
		state_machine.travel("idle")
	
	if(Input.is_action_just_pressed("attack")):
		if(is_on_floor()):
			if(state_machine.get_current_node() == "attack1"):	
				state_machine.travel("attack2")
			elif(state_machine.get_current_node() == "attack2"):	
				state_machine.travel("attack3")
			else:
				state_machine.travel("attack1")
		else:
			if(state_machine.get_current_node() == "jump_attack1"):	
				state_machine.travel("jump_attack2")
			elif(state_machine.get_current_node() == "jump_attack2"):	
				state_machine.travel("jump_attack3")
			else:
				state_machine.travel("jump_attack1")
				
	if(Input.is_action_just_pressed("heavy_attack") and is_on_floor()):
		state_machine.travel("heavy_attack")
	
	if(velocity.x != 0 and velocity.y == 0):
		state_machine.travel("run")
	
	if(velocity.x > 0):
		sprite.scale.x = 0.6
	elif(velocity.x < 0):
		sprite.scale.x = -0.6
		
	if(Input.is_action_just_pressed("dash")):
		state_machine.travel("dash")
	
	if(Input.is_action_pressed("block")):
		state_machine.travel("block")
	
	if !is_on_floor() and Input.is_action_just_pressed('up'):
		state_machine.travel("jump_flip")
		velocity.y = JUMP_SPEED
	
	velocity.x *= WALK_SPEED
		
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
