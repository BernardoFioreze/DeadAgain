extends Label

func _ready():
	update_level_ui()
	Global.player.leveled_up.connect(update_level_ui)
	
func update_level_ui():
	text = "Experience: " + str(Global.player.level)
