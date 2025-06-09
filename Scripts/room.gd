extends Node
class_name Room

@export var next_room_path: String


@onready var turn_manager = preload("res://GameSystem/TurnManager.gd").new()
@onready var player: CharacterBody2D = $Rick

func _ready():
	var zombies = get_tree().get_nodes_in_group("zombies")
	print(self)
	turn_manager.initialize(player,get_tree(), zombies, self)

func _process(delta) -> void:
	var zombies = turn_manager.get_zombies()
	var count := 0
	var droppable_items = turn_manager.get_droppable_items()
	for zombie in zombies:
		if zombie == null:
			continue
		else:
			count += 1
	if count == 0:
		var item_count := 0
		for child in get_children():
			#print(child.get_script() in droppable_items)
			if child.get_script() in droppable_items:
				#print(child)
				item_count += 1
		#print(item_count)
		if item_count == 0:
			#print(children)
			_on_combat_ended()

func _on_combat_ended():
	Global.room_manager.change_room(next_room_path, self)
