extends Panel

@onready var item_visual: Sprite2D = $CenterContainer/Panel/Item_display
@onready var quantidade_label: Label = $CenterContainer/Panel/Label

signal slot_clicked(slot_index: int)
signal drop_finished
signal drag_started

var my_index: int
var inv_ui: InvUi

func set_index(index: int, inv_ui_ref: InvUi):
	my_index = index
	inv_ui = inv_ui_ref

func update(slot: InvSlot, is_selected: bool = false, combinable: bool = false, highlight_ammo: bool = false):
	if !slot.item:
		item_visual.visible = false
		quantidade_label.visible = false
		tooltip_text = "";
	else:
		item_visual.visible = true
		item_visual.texture = slot.item.texture
		if slot.item.is_consumable():
			quantidade_label.visible = true
			quantidade_label.text = str(slot.quantidade)
		else:
			quantidade_label.visible = false
		tooltip_text = slot.item.name;
		

	# Controle de cor:
	if highlight_ammo:
		$Slot.modulate = Color(1, 0.85, 0.1, 0.9)  # amarelo para munição disponível
	elif is_selected:
		$Slot.modulate = Color(0.6, 0.7, 1, 0.9)  # azul para selecionado
	elif combinable:
		$Slot.modulate = Color(0.6, 0.0, 1.0, 0.9)  # roxo para combinável
	else:
		$Slot.modulate = Color(1, 1, 1)
		
func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		emit_signal("slot_clicked", my_index)
		
func _get_drag_data(_at_position):
	var inv = Global.player.inventory
	
	var slot_info = inv.slots[my_index]
	if slot_info.item == null:
		return null  # Não faz drag de slot vazio
		
	drag_started.emit()
		
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
	
	inv_ui.mark_combinable_slots(slot_info.item)
	
	return slot_data
	
func _can_drop_data(_at_position, data):
	return data.has("item") and data.has("index")
	
func _drop_data(_at_position, data):
	if data.index == my_index:
		drop_finished.emit()
		return

	var inv = Global.player.inventory
	var origem = inv.slots[data.index]
	var destino = inv.slots[my_index]

	var mover_tudo = !Input.is_key_pressed(KEY_CTRL)
	var qtd_para_mover = origem.quantidade if mover_tudo else 1

	# Verificar receita
	if origem.item != null and destino.item != null:
		if origem.item.is_receipt_item() and destino.item.is_receipt_item():
			var book = ReceiptBook.new()
			var receipt_item = book.get_receipt(origem.item, destino.item)

			if receipt_item != null:
				var qtd_possivel = 1

				if mover_tudo:
					qtd_possivel = min(origem.quantidade, destino.quantidade)

				var criados = 0

				for i in range(qtd_possivel):
					# 1. Tenta empilhar em um slot já existente com o mesmo item
					var colocado = false
					for s in inv.slots.size():
						if inv.slots[s].item == receipt_item:
							inv.slots[s].quantidade += 1
							colocado = true
							break

					# 2. Se não achou, tenta colocar em um slot vazio
					if not colocado:
						for s in inv.slots.size():
							if inv.slots[s].item == null:
								inv.slots[s].item = receipt_item
								inv.slots[s].quantidade = 1
								colocado = true
								break

					# 3. Se não conseguiu nem empilhar nem colocar, para
					if not colocado:
						break

					# 4. Consome os ingredientes
					origem.quantidade -= 1
					destino.quantidade -= 1
					criados += 1

					if origem.quantidade <= 0:
						origem.item = null
						origem.quantidade = 0
					if destino.quantidade <= 0:
						destino.item = null
						destino.quantidade = 0

				if criados > 0:
					inv.update.emit()
					return

	# Mesmo item e empilhável
	if destino.item == origem.item:
		destino.quantidade += qtd_para_mover
		origem.quantidade -= qtd_para_mover
		if origem.quantidade <= 0:
			origem.item = null
			origem.quantidade = 0
	else:
		# Slot destino vazio — transfere parte ou tudo
		if destino.item == null:
			destino.item = origem.item
			destino.quantidade = qtd_para_mover
			origem.quantidade -= qtd_para_mover
			if origem.quantidade <= 0:
				origem.item = null
				origem.quantidade = 0
		else:
			# Itens diferentes — troca completa
			var temp_item = destino.item
			var temp_qtd = destino.quantidade

			destino.item = origem.item
			destino.quantidade = origem.quantidade

			origem.item = temp_item
			origem.quantidade = temp_qtd

	inv.select(my_index)
	inv.update.emit()
	drop_finished.emit()
	
func is_receipt(item1 : InvItem, item2: InvItem):
	return
