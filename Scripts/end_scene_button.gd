extends Control



func _ready() -> void:
	pass


func _on_button_pressed() -> void:
	Global.room_manager.change_room("res://Scenes/Room.tscn", null)
