extends Node
class_name RoomManager

var current_room
var player_state: Dictionary

var room_change_count : int

func _ready() -> void:
	Global.room_manager = self
	room_change_count = 1

func change_room(room_path: String, room):
	current_room = room
	save_player_state()
	room_change_count += 1
	
	var new_room = load(room_path).instantiate()
	get_tree().root.add_child(new_room)
	
	if current_room:
		current_room.queue_free()
		
	current_room = new_room
	restore_player_state()
	
func get_room_change_count():
	return room_change_count
	
func save_player_state():
	var player = current_room.player
	player_state = {
		"health": player.health,
		"inventory": player.inventory,
		"experience_total": player.experience_total,
		"max_actions": player.max_actions,
		"current_actions": player.current_actions
	}

func restore_player_state():
	var player = current_room.player
	player.health = player_state["health"]
	player.inventory = player_state["inventory"] 
	player.health_bar.health = player_state["health"]
	player.gain_experience(player_state["experience_total"], false)
	player.max_actions = player_state["max_actions"]
	player.current_actions = player_state["current_actions"]
	
func player_dead() -> void:
	var death_scene = ResourceLoader.load("res://Scenes/UI/death_scene_place_holder.tscn")
	var death_instance = death_scene.instantiate()
	get_tree().root.add_child(death_instance)
	print("end")
