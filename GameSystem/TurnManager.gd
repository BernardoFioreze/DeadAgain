extends Node

enum Turn { PLAYER, ZOMBIE }

var turn = Turn.PLAYER
var player
var zombies = []
var player_actions_left: int

func _ready():
	Global.turn_manager = self
	player = $Rick
	zombies = get_tree().get_nodes_in_group("zombies")
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
	await get_tree().create_timer(0.5).timeout
	for zombie in zombies:
		if is_instance_valid(zombie):
			zombie.take_action()
			await get_tree().create_timer(0.5).timeout
	next_turn()

func player_used_action():
	player_actions_left -= 1
	print("Actions left: ", player_actions_left)
	if player_actions_left <= 0:
		next_turn()

func next_turn():
	turn = Turn.ZOMBIE if turn == Turn.PLAYER else Turn.PLAYER
	start_turn()
