extends StaticBody2D

func _ready() -> void:
	drop_from_zombie()
	
func drop_from_zombie():
	$AnimationPlayer.play("dropping_item")
	await get_tree().create_timer(1.0).timeout
	
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		$AnimationPlayer.play("fade")
		await get_tree().create_timer(0.3).timeout
		queue_free()
