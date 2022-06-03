extends KinematicBody2D

var health = 3

func hit():
	health -= 0.5
	print("hit")
	if(health < 0):
		self.remove_child($droneSprite)
		self.remove_child($CollisionShape2D)

