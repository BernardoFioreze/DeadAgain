extends Control

var player_circle
var action_icons: Array

func _ready():
	action_icons = [
		$PlayerTurn1,
		$PlayerTurn2,
		$PlayerTurn3
	]
	player_circle = $PlayerTurn
	update_turn_opacity(3)

func update_turn_opacity(actions_left: int):
	for i in range(action_icons.size()):
		var icon = action_icons[i]
		var visible_actions = action_icons.size()
		
		var alpha := 1.0 if i < actions_left else 0.2
		icon.modulate.a = alpha
