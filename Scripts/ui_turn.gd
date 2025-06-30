extends Control

var player_circle
var action_icons: Array
var max_actions: int = 3  # Quantidade inicial de ações disponíveis

func _ready():
	action_icons = [
		$PlayerTurn1,
		$PlayerTurn2,
		$PlayerTurn3,
		$PlayerTurn4,
		$PlayerTurn5
	]
	
	player_circle = $PlayerTurn

	update_icon_visibility(max_actions)
	update_turn_opacity(max_actions)
	
	Global.player.leveled_up.connect(update_turn_ui_level_up)

func update_icon_visibility(turns: int):
	for i in range(action_icons.size()):
		if i < turns:
			action_icons[i].visible = true
		else:
			action_icons[i].visible = false

func update_turn_opacity(actions_left: int):
	for i in range(action_icons.size()):
		if not action_icons[i].visible:
			continue  # ignora ícones que não estão visíveis

		if i < actions_left:
			action_icons[i].modulate = Color(1, 1, 1, 1)
		else:
			action_icons[i].modulate = Color(1.0, 0.85, 0.1, 0.6)  # amarelo suave para ações não disponíveis

func update_turn_ui_level_up():
	update_icon_visibility(Global.player.max_actions)
	update_turn_opacity(Global.player.current_actions)
	
	
