extends ProgressBar

@onready var label = $Level

func _ready() -> void:
	Global.player.experience_gained.connect(_on_character_experience_gained)
	initialize(Global.player.experience, Global.player.experience_required) 

func initialize(current, maximum):
	max_value = maximum
	value = current
	update_level_label()
	
func _on_character_experience_gained(growth_data):
	for line in growth_data:
		var target_experience = line[0]
		var max_xp = line[1]
		max_value = max_xp
		value = target_experience
		if abs(max_value - value) < 0.01:
			value = min_value
	update_level_label()
	
func update_level_label():
	label.text = str(Global.player.level)
	
