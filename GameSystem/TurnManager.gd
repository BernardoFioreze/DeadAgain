extends Node
class_name TurnManager
enum Turn { PLAYER, ZOMBIE }

var turn: Turn = Turn.PLAYER
var player: CharacterBody2D
var zombies: Array = []
var tree: Object
var droppable_items: Array = [
	load("res://Scripts/granade_collectable.gd")
]
var father
var ui_turn
var player_is_dead = false

func initialize(player_ref: CharacterBody2D, scene_tree: Object, zombies_ref: Array, father_scene):
	Global.turn_manager = self
	player = player_ref
	tree = scene_tree
	zombies = zombies_ref
	for zombie in zombies:
		if is_instance_valid(zombie):
			zombie.zombie_died.connect(_on_zombie_died)
	father = father_scene
	ui_turn = tree.root.find_child("ui_turn", true, false)
	start_turn()

func start_turn():
	match turn:
		Turn.PLAYER:
			Global.player.start_turn()
			if is_instance_valid(ui_turn):
				ui_turn.update_icon_visibility(Global.player.max_actions)
				ui_turn.update_turn_opacity(Global.player.current_actions)
			Global.warning_label.change_label("Vez do jogador!")
		Turn.ZOMBIE:
			Global.warning_label.change_label("Vez dos zumbis!")
			perform_zombie_actions()

func perform_zombie_actions():
	await tree.create_timer(0.5).timeout
	for zombie in zombies:
		if is_instance_valid(zombie):
			zombie.take_action()
			await tree.create_timer(0.5).timeout
			if is_instance_valid(zombie):
				zombie.paint_back()
	while Global.someone_attacking:
		continue
	if not player_is_dead:
		player_is_dead = player.is_dead
	next_turn()

func player_used_action():
	ui_turn = tree.root.find_child("ui_turn", true, false)
	if is_instance_valid(ui_turn):
		ui_turn.update_turn_opacity(Global.player.current_actions)

	if zombies.is_empty():
		Global.player.start_turn()
		ui_turn.update_turn_opacity(Global.player.current_actions)
		return

	if Global.player.current_actions <= 0:
		next_turn()

func next_turn():
	await tree.create_timer(0.5).timeout
	turn = Turn.ZOMBIE if turn == Turn.PLAYER else Turn.PLAYER
	if player_is_dead:
		return
	start_turn.call_deferred()

func get_zombies() -> Array:
	return zombies

func get_droppable_items() -> Array:
	return droppable_items

func _on_zombie_died(z: Zombie):
	if zombies.has(z):
		zombies.erase(z)
