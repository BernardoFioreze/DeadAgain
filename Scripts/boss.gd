extends "res://Scripts/zombie.gd"

func _on_mouse_entered() -> void:
	zombie.modulate = Color(1,2,2,1)
	scale = Vector2(8.40,8.40)
	
	var inv = Global.player.inventory
	
	var cursor_image : Texture2D
	if inv.get_selected_item() != null && inv.get_selected_item().is_attack_item():
		cursor_image = inv.get_selected_item().texture
	else:
		cursor_image = preload("res://Assets/Cursor/blocked_action.png")
		
	Input.set_custom_mouse_cursor(cursor_image, Input.CURSOR_ARROW)

func _on_mouse_exited() -> void:
	zombie.modulate = Color(1,1,1,1)
	scale = Vector2(8,8)
	Input.set_custom_mouse_cursor(null, Input.CURSOR_ARROW)
