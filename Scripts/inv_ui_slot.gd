extends Panel

@onready var item_visual: Sprite2D = $CenterContainer/Panel/Item_display
@onready var quantidade_label: Label = $CenterContainer/Panel/Label

signal slot_clicked(slot_index: int)

var my_index: int

func set_index(index: int):
	my_index = index

func update (slot: InvSlot, is_selected: bool = false):
	if !slot.item:
		item_visual.visible = false
		quantidade_label.visible = false
	else:
		item_visual.visible = true
		item_visual.texture = slot.item.texture
		if slot.item.is_consumable():
			quantidade_label.visible = true
			quantidade_label.text = str(slot.quantidade)
		else:
			quantidade_label.visible = false
	
	$Slot.modulate = Color(0.6,0.7,1, 0.9) if is_selected else Color(1,1,1)


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		emit_signal("slot_clicked", my_index)
