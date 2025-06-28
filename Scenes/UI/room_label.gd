extends Label

func _ready() -> void:
	var rm = Global.room_manager
	if rm == null:
		text = "Quarto: 1"
	else:
		text = "Quarto: " + str(Global.room_manager.get_room_change_count())
