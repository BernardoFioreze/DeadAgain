extends Button

var cr

func _ready() -> void:
	Global.next_button = self
	visible = false

func _on_pressed() -> void:
	if cr:
		print("teste")
		cr._on_combat_ended()
	
func turn_visible(current_room):
	cr = current_room
	visible = true
