extends Node
class_name Room

@onready var turn_manager = preload("res://GameSystem/TurnManager.gd").new()
@onready var player: CharacterBody2D = $Rick
@onready var spawn_area = $SpawnArea

var zombie_count: int
var zombies = []

var spawned_positions = []

func _ready():
	randomize()
	spawned_positions.clear()
	
	if Global.room_manager != null && Global.room_manager.get_room_change_count() % 3 == 0:
		zombie_count = randi_range(1, 2) 
		_spawn_boss()
	else:
		zombie_count = randi_range(2, 4) 
	_spawn_zombies()
	
	Global.player.connect_zombies()
	
	# Atualiza a lista de zumbis para o turn manager
	zombies = get_tree().get_nodes_in_group("zombies")
	turn_manager.initialize(player, get_tree(), zombies, self)

func _spawn_zombies():
	var zombie_scene = preload("res://Scenes/zombie.tscn")
	var rect_shape = spawn_area.get_node("CollisionShape2D").shape as RectangleShape2D
	var global_pos = spawn_area.global_position
	var extents = rect_shape.extents
	
	var min_distance = 100
	var min_distance_sq = min_distance * min_distance
	
	for i in range(zombie_count):
		var spawn_pos = Vector2()
		var tries = 0
		while true:
			spawn_pos = _get_random_position(global_pos, extents)
			var too_close = false
			for pos in spawned_positions:
				if spawn_pos.distance_squared_to(pos) < min_distance_sq:
					too_close = true
					break
			tries += 1
			if not too_close or tries > 20:
				break
				
		var zombie = zombie_scene.instantiate()
		zombie.position = spawn_pos
		add_child(zombie)
		spawned_positions.append(spawn_pos)

func _spawn_boss():
	var boss_scene = preload("res://Scenes/Boss.tscn")
	var boss = boss_scene.instantiate()
	
	var rect_shape = spawn_area.get_node("CollisionShape2D").shape as RectangleShape2D
	var global_pos = spawn_area.global_position
	var extents = rect_shape.extents
	
	var min_distance = 300
	var min_distance_sq = min_distance * min_distance
	
	var spawn_pos = Vector2()
	var tries = 0
	var y_top = global_pos.y - extents.y                      
	var y_middle = global_pos.y                               
	var x_min = global_pos.x - extents.x
	var x_max = global_pos.x + extents.x
	while true:
		var x = randf_range(global_pos.x - extents.x, global_pos.x + extents.x)
		var y = randf_range(y_top, y_middle)
		spawn_pos = Vector2(x, y)
		var too_close = false
		for pos in spawned_positions:
			if spawn_pos.distance_squared_to(pos) < min_distance_sq:
				too_close = true
				break
		tries += 1
		if not too_close or tries > 20:
			break
	
	boss.position = spawn_pos
	add_child(boss)
	spawned_positions.append(spawn_pos)

func _get_random_position(area_pos: Vector2, extents: Vector2, min_y_override: float = -INF) -> Vector2:	
	var x = randf_range(area_pos.x - extents.x, area_pos.x + extents.x)
	var y_min = max(area_pos.y - extents.y, min_y_override)
	var y_max = area_pos.y + extents.y
	var y = randf_range(y_min, y_max)
	return Vector2(x, y)

func _process(delta) -> void:
	var current_zombies = turn_manager.get_zombies()
	var count := 0
	var droppable_items = turn_manager.get_droppable_items()
	for zombie in current_zombies:
		if zombie == null:
			continue
		else:
			count += 1
	if count == 0:
		var item_count := 0
		for child in get_children():
			if child.get_script() in droppable_items:
				item_count += 1
		if item_count == 0:
			_on_combat_ended()

func _on_combat_ended():
	Global.room_manager.change_room("res://Scenes/Room.tscn", self)
