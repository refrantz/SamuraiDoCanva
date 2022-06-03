extends KinematicBody2D

const GRAVITY = 1600.0
const JUMP_SPEED = -550
const WALK_SPEED = 400

var jumping = false
var velocity = Vector2()
onready var sprite := $PlayerSprite
var state_machine
var lastflip
var dash_speedx = 1000
var dash_speedy = 350
var dash_duration = 0.2
var health = 5
var hit = false
var dead = false
var accumulated = 20

onready var dash = $dash

func flip_h(flip:bool):
	var x_axis = global_transform.x
	global_transform.x.x = (-1 if flip else 1) * abs(x_axis.x)
	if flip:
		lastflip = true
		
	else:
		lastflip = false

func _ready():
	state_machine = $AnimationTree.get("parameters/playback")

func get_input():
	velocity.x = Input.get_action_strength("right")-Input.get_action_strength("left")
	var jump = Input.is_action_just_pressed('up')
	
	if(velocity.x != 0 and velocity.y == 0 and state_machine.get_current_node() != "run"):
		state_machine.travel("run")
		
	if(velocity.x == 0 and velocity.y == 0  and state_machine.get_current_node() != "attack1" and state_machine.get_current_node() != "attack2" and state_machine.get_current_node() != "idle"):
		state_machine.travel("idle")

	flip_h(velocity.x < 0 or lastflip)
	
	if(velocity.x > 0):
		lastflip = false
	
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
		
	if(Input.is_action_just_pressed("dash") and dash.can_dash and !dash.is_dashing()):
		dash.start_dash(dash_duration)
		state_machine.travel("dash")
	
	if(Input.is_action_pressed("block")):
		state_machine.travel("block")
		
	if(dash.is_dashing()):
		if(Input.is_action_pressed("down")):
			velocity.y = dash_speedy
		elif(Input.is_action_pressed("up")):
			velocity.y = -dash_speedy
		state_machine.travel("dash")
	
	if !is_on_floor() and Input.is_action_just_pressed('up'):
		state_machine.travel("jump_flip")
		velocity.y = JUMP_SPEED
	
	velocity.x *= dash_speedx if dash.is_dashing() else WALK_SPEED
		
	if jump and is_on_floor():
		state_machine.travel("jump")
		jumping = true
		velocity.y = JUMP_SPEED
		
func hurt():
	state_machine.travel("knockback")
	health -= 1
	if(health < 1):
		death()
		
func death():
	velocity.x = 0
	dead = true
	state_machine.travel("death")
	

func _physics_process(delta):
	
	if(state_machine.get_current_node() == "knockback"):
		hit = true
	
	if(!hit and !dead):
		accumulated = 20
		get_input()
	elif(hit and !dead):
		velocity.x = 500 if lastflip else -500
		velocity.x -= accumulated if lastflip else -accumulated
		accumulated += 20

		
	if(state_machine.get_current_node() != "knockback"):
		hit = false
		
	velocity.y += GRAVITY * delta
	
	if jumping and is_on_floor():
		jumping = false
	
	velocity = move_and_slide(velocity, Vector2(0, -1))


func _on_PlayerDetection_body_entered(body):
	if(state_machine.get_current_node() != "block" and !dash.is_dashing() and body.is_in_group("Enemies") and !hit and !dead):
		hit = true
		hurt()
		print("hurt")


func _on_Weapon_body_entered(body):
	if(body.is_in_group("Hittable")):
		body.hit()
