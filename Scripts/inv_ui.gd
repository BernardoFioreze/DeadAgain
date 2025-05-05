extends Control

@onready var inv: Inv = preload("res://Inventory/playerinv.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

var is_open = false

func _ready() -> void:
	inv.update.connect(update_slots)
	for i in range(slots.size()):
		slots[i].set_index(i)
		slots[i].slot_clicked.connect(_on_slot_clicked)
	update_slots()
	close()
	
func update_slots():
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].update(inv.slots[i], i == inv.selected_index)
		
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
