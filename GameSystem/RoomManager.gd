extends Node
class_name RoomManager

var current_room = null
var player_state: Dictionary = {
		"health": 100,
		"inventory": null,
		"experience_total": 0,
		"max_actions": 3,
		"current_actions": 3
	}
var saved := false
var room_change_count : int
var player : CharacterBody2D

func _ready() -> void:
	Global.room_manager = self
	room_change_count = 1

func change_room(room_path: String, room):
	for child in Global.room_manager.get_children():
		child.queue_free()
	if room != null and current_room == null:
		current_room = room
		save_player_state()
		room_change_count += 1
	
	var new_room = load(room_path).instantiate()
	Global.room_manager.add_child(new_room)
	
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

func save_player_state_restart():
	var player_aux = current_room.player
	player = player_aux
	player_state = {
		"health": 100,
		"inventory": player.inventory,
		"experience_total": player.experience_total,
		"max_actions": player.max_actions,
		"current_actions": player.max_actions
	}
	saved = true

func restore_player_state():
	var player = current_room.player
	player.is_dead = false
	player.health = player_state["health"]
	if player_state["inventory"] != null:
		player.inventory = player_state["inventory"] 
	player.health_bar.health = player_state["health"]
	player.gain_experience(player_state["experience_total"], false)
	player.max_actions = player_state["max_actions"]
	player.current_actions = player_state["current_actions"]
	
func player_dead(room) -> void:
	if current_room == null:
		current_room = room
	room.finish_turn_manager()
	await get_tree().create_timer(2.0).timeout
	var death_scene = ResourceLoader.load("res://Scenes/UI/EndScene.tscn")
	var death_instance = death_scene.instantiate()
	save_player_state_restart()
	while not saved:
		continue
	false
	cleanup()
	Global.room_manager.add_child(death_instance)
	print("end")

func cleanup():
	for child in Global.room_manager.get_children():
		child.queue_free()
