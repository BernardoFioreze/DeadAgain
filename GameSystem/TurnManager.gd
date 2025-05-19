extends Node
class_name TurnManager
enum Turn { PLAYER, ZOMBIE }

signal ended(victory)
var turn: Turn = Turn.PLAYER
var player: CharacterBody2D
var zombies: Array = []
var player_actions_left: int
var tree: Object
var droppable_items: Array = [
	"res://Scripts/granade_collectable.gd"
	]
var father

func initialize(player_ref: CharacterBody2D, scene_tree: Object, zombies_ref: Array, father_scene):
	Global.turn_manager = self
	player = player_ref
	tree = scene_tree
	zombies = zombies_ref
	father = father_scene
	start_turn()

func start_turn():
	match turn:
		Turn.PLAYER:
			player_actions_left = 3
			print("Player's Turn!")
		Turn.ZOMBIE:
			print("Zombies' Turn!")
			perform_zombie_actions()

func perform_zombie_actions():
	await tree.create_timer(0.5).timeout
	for zombie in zombies:
		if is_instance_valid(zombie):
			zombie.take_action()
			await tree.create_timer(0.5).timeout
	if player.health == 0:
		ended.emit(false)
	next_turn()

func player_used_action():
	
	player_actions_left -= 1
	print("Actions left: ", player_actions_left)
	var count := 0
	var children = father.get_children()
	for zombie in zombies:
		if zombie == null:
			continue
		else:
			count += 1
	if count == 0:
		var item_count := 0
		for child in children:
			if child.get_script() in droppable_items:
				count += 1
		if item_count == 0:
			ended.emit(true)
	if player_actions_left <= 0:
		next_turn()

func next_turn():
	turn = Turn.ZOMBIE if turn == Turn.PLAYER else Turn.PLAYER
	start_turn()
