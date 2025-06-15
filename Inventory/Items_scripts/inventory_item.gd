extends Resource

class_name InvItem

@export var name: String = ""
@export var texture: Texture2D

@export_enum("Heal", "Attack", "Receipt") var item_type: String
@export var consumable: bool
@export var intensity: int #Power for attack itens, healing for healing items
@export var areaDamage: bool
@export var requiresAmmo: bool
@export var missPercentage: float
@export var requiredAmmo: InvItem

func is_healing_item():
	return item_type == "Heal"
	
func is_attack_item():
	return item_type == "Attack"
	
func is_receipt_item():
	return item_type == "Receipt"

func is_consumable():
	return consumable

func get_intensity():
	return intensity
	
func get_miss_percentage():
	return missPercentage
	
func get_required_ammo():
	return requiredAmmo
	
func is_area_damage():
	return areaDamage

func requires_ammo():
	return requiresAmmo
	
