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
	# Decrease item quantity and remove if no quantity left
	var selected_slot = get_selected_slot()
	if selected_slot:
		selected_slot.quantidade -= 1
		if selected_slot.quantidade <= 0:
			selected_slot.item = null  # Remove item from the slot
			selected_slot.quantidade = 0  # Ensure quantity is reset

	update.emit()  # Emit update signal to refresh inventory
	
