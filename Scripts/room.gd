extends Node
class_name Room

@export var next_room_path: String


@onready var turn_manager = preload("res://GameSystem/TurnManager.gd").new()
@onready var player: CharacterBody2D = $Rick

func _ready():
	turn_manager.ended.connect(_on_combat_ended)
	
	var zombies = get_tree().get_nodes_in_group("zombies")
	print(self)
	turn_manager.initialize(player,get_tree(), zombies, self)

func _on_combat_ended(result):
	if result == true:
		Global.room_manager.change_room(next_room_path, self)
