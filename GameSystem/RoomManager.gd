extends Node
class_name RoomManager

var current_room
var player_state: Dictionary

func _ready() -> void:
	Global.room_manager = self

func change_room(room_path: String, room):
	current_room = room
	save_player_state()
	
	var new_room = load(room_path).instantiate()
	get_tree().root.add_child(new_room)
	
	if current_room:
		current_room.queue_free()
		
	current_room = new_room
	restore_player_state()
	
	
func save_player_state():
	var player = current_room.player
	player_state = {
		"health": player.health,
		"inventory": player.inventory,
		"experience_total": player.experience_total,
	}

func restore_player_state():
	var player = current_room.player
	player.health = player_state["health"]
	player.inventory = player_state["inventory"] 
	player.health_bar.health = player_state["health"]
	player.gain_experience(player_state["experience_total"])
