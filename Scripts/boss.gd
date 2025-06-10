extends "res://Scripts/zombie.gd"

func _on_mouse_entered() -> void:
	zombie.modulate = Color(1,2,2,1)
	scale = Vector2(8.40,8.40)

func _on_mouse_exited() -> void:
	zombie.modulate = Color(1,1,1,1)
	scale = Vector2(8,8)
