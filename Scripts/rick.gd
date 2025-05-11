extends CharacterBody2D
class_name Rick

@export var inventory: Inv
@export var health: int

@onready var health_bar = $HealthBar
@onready var rick = $Rick

var attack_force: int = 25

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

	zombie.take_damage(attack_force)
	Global.turn_manager.player_used_action()

func suffer_damage(damage: int):
	var left_health = health - damage
	_set_health(left_health)

func _set_health(value: int):
	health = max(value, 0)
	health_bar.health = health
	if health <= 0:
		print("Player died!")
		queue_free()

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		print("Clique")

func _on_mouse_entered() -> void:
	modulate = Color(2,1,1,1)
	scale = Vector2(1.05,1.05)

func _on_mouse_exited() -> void:
	modulate = Color(1,1,1,1)
	scale = Vector2(1,1)
	
func collect(item): 
	inventory.insert(item)
	Global.turn_manager.player_used_action()
		
