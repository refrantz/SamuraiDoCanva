extends TextureRect

func _ready():
	$TextureProgress.value = 5
	
func set_percent_value_int(value):
	$TextureProgress.value = value
