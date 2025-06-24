extends Resource

class_name Inv

signal update

@export var slots: Array[InvSlot]

var selected_index: int = -1

func insert(item: InvItem):
	var itemslots = slots.filter(func(slot): return slot.item == item)
	if !itemslots.is_empty():
		itemslots[0].quantidade += 1
	else:
		var emptyslots = slots.filter(func(slot): return slot.item == null)
		if !emptyslots.is_empty():
			emptyslots[0].item = item
			emptyslots[0].quantidade = 1
	update.emit()
	
func select(index: int) -> void:
	if index >= 0 and index < slots.size():
		selected_index = index
		update.emit()
		
func get_selected_item() -> InvItem:
	if selected_index >= 0 and selected_index < slots.size():
		return slots[selected_index].item
	return null

func get_selected_slot() -> InvSlot:
	if selected_index >= 0 and selected_index < slots.size():
		return slots[selected_index]
	return null

func consume() -> void:
	var selected_slot = get_selected_slot()
	if selected_slot:
		selected_slot.quantidade -= 1
		if selected_slot.quantidade <= 0:
			selected_slot.item = null 
			selected_slot.quantidade = 0

	update.emit() 

func consume_item(item_to_consume: InvItem) -> void:
	for slot in slots:
		if slot.item == item_to_consume and slot.quantidade > 0:
			slot.quantidade -= 1
			if slot.quantidade <= 0:
				slot.item = null 
				slot.quantidade = 0
			update.emit()
			return
	
func has_item(item_to_find: InvItem) -> bool:
	for slot in slots:
		if slot.item == item_to_find and slot.quantidade > 0:
			return true
	return false
	
func is_full_for_item(item: InvItem) -> bool:
	for slot in slots:
		# Se o slot está vazio, cabe o item
		if slot.item == null:
			return false

		# Se o slot contém o mesmo item
		if slot.item == item:
			return false

	# Se nenhum slot pode aceitar o item, está "cheio"
	return true

	
