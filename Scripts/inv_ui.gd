extends Control

class_name InvUi

@onready var inv: Inv = preload("res://Inventory/playerinv.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

func _ready() -> void:
	inv.update.connect(update_slots)
	for i in range(slots.size()):
		slots[i].set_index(i, self)
		slots[i].slot_clicked.connect(_on_slot_clicked)
		slots[i].drop_finished.connect(_on_drop_finished)
	update_slots()
	visible = true
	
func update_slots(combinable_item: InvItem = null):
	var selected_item = inv.get_selected_item()
	var required_ammo: InvItem = null

	if selected_item and selected_item.requires_ammo():
		required_ammo = selected_item.get_required_ammo()

	for i in range(min(inv.slots.size(), slots.size())):
		var combinable := false
		if combinable_item and inv.slots[i].item:
			var book = ReceiptBook.new()
			combinable = book.get_receipt(inv.slots[i].item, combinable_item) != null

		var highlight_ammo := false
		if required_ammo and inv.slots[i].item == required_ammo and inv.slots[i].quantidade > 0:
			highlight_ammo = true

		slots[i].update(inv.slots[i], i == inv.selected_index, combinable, highlight_ammo)
		
func _on_slot_clicked(index: int):
	inv.select(index)
	update_slots()
	
func get_selected_slot() -> InvSlot:
	return inv.get_selected_slot()
	
	
func mark_combinable_slots(dragged_item: InvItem):
	for i in range(min(inv.slots.size(), slots.size())):
		var combinable := false
		var slot_item = inv.slots[i].item
		if slot_item and dragged_item:
			if slot_item.is_receipt_item() and dragged_item.is_receipt_item():
				var book = ReceiptBook.new()
				combinable = book.get_receipt(slot_item, dragged_item) != null
		slots[i].update(inv.slots[i], i == inv.selected_index, combinable)

func _on_drop_finished():
	clear_combinable()

func clear_combinable():
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].update(inv.slots[i], i == inv.selected_index, false)
