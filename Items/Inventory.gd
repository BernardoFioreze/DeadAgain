class_name Inventory
extends Node


var items: Array[Item] = []

func add_item(item: Item) -> bool:
	for element in items:
		if element.id == item.id and element.stack < element.max_stack:
			if item.stack + element.stack > element.max_stack:
				element.stack += element.max_stack - element.stack
				return true
			else:
				element.stack += item.stack
				return true
	items.append(item)
	return true

func consume_item(item: Item) -> bool:
	if item.consumable:
		return true
	return false

func delete_item(item: Item) -> bool:
	var count: int = 0
	for element in items:
		if element.id == item.id:
			items.remove_at(count)
			return true
		count += 1 
	return false
