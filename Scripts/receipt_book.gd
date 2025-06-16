extends Node
class_name ReceiptBook

# Dicionário de receitas: chaves são tuplas de nomes de itens, valores são nomes do item resultante
var receitas = {
	["flask", "herb"]: "heal_potion",
	["gunpowder", "shotgunCase"]: "shotgunAmmo",
	["gunpowder", "sniperCase"]: "sniperAmmo"
}

var item_paths = {
	"heal_potion" : "res://Inventory/Items_resources/heal_potion.tres",
	"shotgunAmmo" : "res://Inventory/Items_resources/shotgunAmmo.tres",
	"sniperAmmo" : "res://Inventory/Items_resources/sniperAmmo.tres"
}

func get_receipt(item1: InvItem, item2: InvItem) -> InvItem:
	# Ordena nomes para evitar problema de ordem (Erva + Frasco vazio == Frasco vazio + Erva)
	var key = [item1.name, item2.name]
	key.sort()
	
	var result = null
	
	for receita_key in receitas.keys():
		var sorted_key = receita_key.duplicate()
		sorted_key.sort()
		if sorted_key == key:
			return get_item_reference(receitas[receita_key])
			
	return result

func get_item_reference(nome : String) -> InvItem:
	if nome in item_paths:
		return load(item_paths[nome])
	return null
	
