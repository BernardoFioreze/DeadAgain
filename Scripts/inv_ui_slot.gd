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
		
func _get_drag_data(_at_position):
	var inv = Global.player.inventory
	
	var slot_info = inv.slots[my_index]
	if slot_info.item == null:
		return null  # Não faz drag de slot vazio
		
	var slot_data = {
		"index": my_index,
		"item": inv.slots[my_index].item,
		"quantidade": inv.slots[my_index].quantidade
	}
	
	var preview = TextureRect.new()
	preview.texture = item_visual.texture
	preview.expand_mode = TextureRect.EXPAND_KEEP_SIZE
	preview.custom_minimum_size = Vector2(32, 32)
	preview.modulate = Color(1, 1, 1, 0.7)

	set_drag_preview(preview)
	return slot_data
	
func _can_drop_data(_at_position, data):
	return data.has("item") and data.has("index")

func _drop_data(_at_position, data):
	if data.index == my_index:
		return  

	var inv = Global.player.inventory
	var origem = inv.slots[data.index]
	var destino = inv.slots[my_index]


	var temp_item = destino.item
	var temp_qtd = destino.quantidade

	destino.item = origem.item
	destino.quantidade = origem.quantidade

	origem.item = temp_item
	origem.quantidade = temp_qtd
	
	inv.select(my_index)

	inv.update.emit()
