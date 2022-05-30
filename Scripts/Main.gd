extends Node2D

var total : int = 0

func _ready() -> void:
	pass 
	
func update_score(current_score : float) -> void:
	$Score.text = str(current_score)
	
func _process(delta: float) -> void:
	total += 1
	update_score(total)
