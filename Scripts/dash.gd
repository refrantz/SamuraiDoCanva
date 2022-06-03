extends Node2D

const dash_delay = 0.4

onready var duration_timer = $durationTimer
var can_dash = true

func start_dash(duration):
		duration_timer.wait_time = duration
		duration_timer.start()
		
func is_dashing():
	return !duration_timer.is_stopped()
	
func end_dash():
	can_dash = false
	yield(get_tree().create_timer(dash_delay), "timeout")
	can_dash = true

func _on_durationTimer_timeout():
	end_dash()
