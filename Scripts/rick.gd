extends CharacterBody2D
class_name Rick

@export var inventory: Inv
@export var health: int

@export var level: int = 1

@onready var health_bar = $HealthBar
@onready var rick = $RickAnimatedSprite
@onready var max_health = health

signal leveled_up()
signal experience_gained(growth_data)

var experience = 0
var experience_total = 0
var experience_required = get_required_xp(level + 1)
@onready var is_dead = false
var max_actions: int = 3
var current_actions: int = max_actions

func _ready() -> void:
	Global.player = self
	health_bar.init_health(health)
		
func connect_zombies():
	for zombie in get_tree().get_nodes_in_group("zombies"):
		zombie.connect("clicked", _on_zombie_clicked)

func start_turn():
	current_actions = max_actions

func use_action():
	current_actions -= 1
	if current_actions < 0:
		current_actions = 0

func can_act() -> bool:
	return current_actions > 0

func _on_zombie_clicked(zombie: Zombie):
	if Global.turn_manager.turn != Global.turn_manager.Turn.PLAYER:
		return

	if not can_act():
		Global.warning_label.change_label("Jogador sem ações")
		return
		
	var selected_item = inventory.get_selected_item()
	if selected_item == null:
		Global.warning_label.change_label("Selecione um item válido")
		return
		
	if !selected_item.is_attack_item():
		Global.warning_label.change_label("Selecione um item de ataque")
		return
	
	if selected_item.is_consumable():
		inventory.consume()
		
	if selected_item.requires_ammo():
		var ammo_id = selected_item.get_required_ammo()
		if inventory.has_item(ammo_id):
			inventory.consume_item(ammo_id)
		else:
			Global.warning_label.change_label("Arma sem munição")
			return
			
	if 1.0 - selected_item.get_miss_percentage() > randf():
		zombie.take_damage(selected_item.get_intensity())
		
		if selected_item.is_area_damage():
			for z in get_tree().get_nodes_in_group("zombies"):
				if z != zombie:
					z.take_damage(selected_item.get_intensity() * 0.3)
			suffer_damage(selected_item.get_intensity() * 0.1)
	else:
		Global.warning_label.change_label("Errou o ataque")
	
	use_action()
	Global.turn_manager.player_used_action()

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if Global.turn_manager.turn != Global.turn_manager.Turn.PLAYER:
			return

		if not can_act():
			Global.warning_label.change_label("Jogador sem ações")
			return
			
		var selected_item = inventory.get_selected_item()
		if selected_item == null:
			Global.warning_label.change_label("Selecione um item válido")
			return
			
		if !selected_item.is_healing_item():
			Global.warning_label.change_label("Selecione um item de cura")
			return
		
		if selected_item.is_consumable():
			inventory.consume()
		
		heal(selected_item.get_intensity())
		use_action()
		Global.turn_manager.player_used_action()

func _on_mouse_entered() -> void:
	rick.modulate = Color(2,1,1,1)
	scale = Vector2(4.20,4.20)
	
	var cursor_image : Texture2D
	if inventory.get_selected_item() != null && inventory.get_selected_item().is_healing_item():
		cursor_image = inventory.get_selected_item().texture
	else:
		cursor_image = preload("res://Assets/Cursor/blocked_action.png")
		
	Input.set_custom_mouse_cursor(cursor_image, Input.CURSOR_ARROW)

func _on_mouse_exited() -> void:
	rick.modulate = Color(1,1,1,1)
	scale = Vector2(4,4)
	Input.set_custom_mouse_cursor(null, Input.CURSOR_ARROW)
	
func collect(item): 
	inventory.insert(item)
	use_action()
	Global.turn_manager.player_used_action()
	
func suffer_damage(damage: int):
	var left_health = health - damage
	_set_health(left_health)
	
func heal(heal: int):
	var left_health = health + heal
	_set_health(left_health)

func _set_health(value: int):
	health = max(value, 0)
	health = min(value, max_health)
	health_bar.health = health
	if health <= 0:
		if not is_dead:
			is_dead = true
			Global.room_manager.player_dead(Global.room_manager.get_child(-1))
		
func get_required_xp(level):
	return round(pow(level, 1.8) + level * 4)

func gain_experience(amount, shouldIncreaseHealth : bool):
	experience_total += amount
	experience += amount
	var growth_data = []
	while experience >= experience_required:
		experience -= experience_required
		growth_data.append([experience_required, experience_required])
		level_up(shouldIncreaseHealth)
	growth_data.append([experience, experience_required])
	experience_gained.emit(growth_data)
		
func level_up(shouldIncreaseHealth : bool):
	level += 1
	experience_required = get_required_xp(level + 1)
	if shouldIncreaseHealth:
		_set_health(max_health)
	if max_actions < 5 && level % 3 == 0:
		max_actions += 1
	leveled_up.emit()
	
func level_up_emit():
	leveled_up.emit()	
