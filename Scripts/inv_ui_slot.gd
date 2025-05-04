extends Panel

@onready var item_visual: Sprite2D = $CenterContainer/Panel/Item_display
@onready var quantidade_label: Label = $CenterContainer/Panel/Label

func update (slot: InvSlot):
	if !slot.item:
		item_visual.visible = false
		quantidade_label.visible = false
	else:
		item_visual.visible = true
		item_visual.texture = slot.item.texture
		quantidade_label.visible = true
		quantidade_label.text = str(slot.quantidade)
