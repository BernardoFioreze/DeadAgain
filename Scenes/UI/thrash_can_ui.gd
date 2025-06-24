extends TextureRect

@onready var inv = Global.player.inventory

@onready var thrash_normal = preload("res://Assets/Inventory/thrashcan.png")
@onready var thrash_hover = preload("res://Assets/Inventory/thrashcan_hover.png")

func _can_drop_data(_pos, data) -> bool:
	return data.has("item") and data.has("index")

func _drop_data(_pos, data) -> void:
	if not data.has("index"):
		return

	var index = data.index
	var slot = inv.slots[index]
	var ctrl_pressed = Input.is_key_pressed(KEY_CTRL)

	if ctrl_pressed:
		# Deleta apenas 1 unidade
		slot.quantidade -= 1
		if slot.quantidade <= 0:
			slot.item = null
			slot.quantidade = 0
	else:
		# Deleta tudo
		slot.item = null
		slot.quantidade = 0

	inv.select(-1)
	inv.update.emit()
	mouse_exited()

func mouse_entered():
	texture = thrash_hover
	modulate = Color(1, 0.2, 0.2, 1.0)  # vermelho ao arrastar sobre

func mouse_exited():
	texture = thrash_normal
	modulate = Color(1, 1, 1, 1)  # volta ao normal
