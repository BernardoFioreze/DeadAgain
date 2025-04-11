extends CharacterBody2D




func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		print("Clique")


func _on_mouse_entered() -> void:
	modulate = Color(2,1,1,1)
	scale = Vector2(1.05,1.05)


func _on_mouse_exited() -> void:
	modulate = Color(1,1,1,1)
	scale = Vector2(1,1)
