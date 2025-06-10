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

func _ready() -> void:
	Global.player = self
	health_bar.init_health(health)

	for zombie in get_tree().get_nodes_in_group("zombies"):
		zombie.connect("clicked", _on_zombie_clicked)

func _on_zombie_clicked(zombie: Zombie):
	if Global.turn_manager.turn != Global.turn_manager.Turn.PLAYER:
		return

	if Global.turn_manager.player_actions_left <= 0:
		print("No actions left!")
		return
		
	var selected_item = inventory.get_selected_item()
	
	if selected_item == null:
		print("Select a valid item")
		return
		
	if !selected_item.is_attack_item():
		print("Select an attack item")
		return
	
	if selected_item.is_consumable():
		inventory.consume()
		
	zombie.take_damage(selected_item.get_intensity())
	Global.turn_manager.player_used_action()

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if Global.turn_manager.turn != Global.turn_manager.Turn.PLAYER:
			return

		if Global.turn_manager.player_actions_left <= 0:
			print("No actions left!")
			return
			
		var selected_item = inventory.get_selected_item()
		
		if selected_item == null:
			print("Select a valid item")
			return
			
		if !selected_item.is_healing_item():
			print("Select an healing item")
			return
		
		if selected_item.is_consumable():
			inventory.consume()
		
		heal(selected_item.get_intensity())
		Global.turn_manager.player_used_action()

func _on_mouse_entered() -> void:
	rick.modulate = Color(2,1,1,1)
	scale = Vector2(4.20,4.20)

func _on_mouse_exited() -> void:
	rick.modulate = Color(1,1,1,1)
	scale = Vector2(4,4)
	
func collect(item): 
	inventory.insert(item)
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
		print("Player died!")
		queue_free()
		
func get_required_xp(level):
	return round(pow(level, 1.8) + level * 4)

func gain_experience(amount):
	experience_total += amount
	experience += amount
	var growth_data = []
	while experience >= experience_required:
		experience -= experience_required
		growth_data.append([experience_required, experience_required])
		level_up()
	growth_data.append([experience, experience_required])
	experience_gained.emit(growth_data)
		
func level_up():
	level += 1
	experience_required = get_required_xp(level + 1)
	_set_health(max_health)
	leveled_up.emit()
	
