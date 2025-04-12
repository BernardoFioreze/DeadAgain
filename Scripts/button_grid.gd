extends Button

@export var button_id: int = 0
signal button_signal(button_id)


func _ready() -> void:
	add_to_group("selected_buttons")
	connect("pressed", _on_pressed)
	
func _on_pressed():
	emit_signal("button_signal", button_id)
	print("signal")
