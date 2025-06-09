extends Control

class_name InvUi

@onready var inv: Inv = preload("res://Inventory/playerinv.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

var is_open = false

func _ready() -> void:
	inv.update.connect(update_slots)
	for i in range(slots.size()):
		slots[i].set_index(i, self)
		slots[i].slot_clicked.connect(_on_slot_clicked)
		slots[i].drop_finished.connect(_on_drop_finished)
	update_slots()
	close()
	
func update_slots(combinable_item: InvItem = null):
	for i in range(min(inv.slots.size(), slots.size())):
		var combinable := false
		if combinable_item and inv.slots[i].item:
			var book = ReceiptBook.new()
			combinable = book.get_receipt(inv.slots[i].item, combinable_item) != null

		slots[i].update(inv.slots[i], i == inv.selected_index, combinable)

		
func _on_slot_clicked(index: int):
	inv.select(index)
	update_slots()
	
func get_selected_slot() -> InvSlot:
	return inv.get_selected_slot()
	
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("i"):
		if is_open:
			close()
		else:
			open()

func open():
	visible = true
	is_open = true

func close():
	visible = false
	is_open = false
	inv.selected_index = -1
	
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
