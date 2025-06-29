extends Label

var timer_on : bool

func _ready() -> void:
	Global.warning_label = self
	text = ""
	timer_on = false
	
func change_label(text_to_print: String):
	if timer_on:
		return
	timer_on = true
	text = text_to_print
	await get_tree().create_timer(1.25).timeout
	text = ""
	timer_on = false
