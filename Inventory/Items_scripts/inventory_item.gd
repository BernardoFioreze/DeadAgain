extends Resource

class_name InvItem

@export var name: String = ""
@export var texture: Texture2D

@export_enum("Heal", "Attack") var item_type: String
@export var consumable: bool
@export var intensity: int #Power for attack itens, healing for healing items

func is_healing_item():
	return item_type == "Heal"
	
func is_attack_item():
	return item_type == "Attack"

func is_consumable():
	return consumable

func get_intensity():
	return intensity
	
