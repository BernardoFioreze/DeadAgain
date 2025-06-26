extends CharacterBody2D
class_name Zombie

@onready var health_bar = $HealthBar
@onready var zombie = $ZombieAnimatedSprite

@export var attack_force: int
@export var health : int
@export var is_boss: bool

signal clicked(zombie)
signal zombie_died(zombie)

var droppable_items: Array = [
	preload("res://Scenes/Collectables/sniperCase_collectable.tscn"),
	preload("res://Scenes/Collectables/shotgunCase_collectable.tscn"),
	preload("res://Scenes/Collectables/gunpowder_collectable.tscn"),
	preload("res://Scenes/Collectables/flask_collectable.tscn"),
	preload("res://Scenes/Collectables/herb_collectable.tscn"),
	preload("res://Scenes/Collectables/metalScrap_collectable.tscn"),
]

func _ready() -> void:
	health_bar.init_health(health)
	if is_boss:
		droppable_items.clear()
		droppable_items.append(preload("res://Scenes/Collectables/rpgAmmo_collectable.tscn"))		
		droppable_items.append(preload("res://Scenes/Collectables/sniperAmmo_collectable.tscn"))
		droppable_items.append(preload("res://Scenes/Collectables/shotgunAmmo_collectable.tscn"))
		droppable_items.append(preload("res://Scenes/Collectables/medkit_collectable.tscn"))

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		emit_signal("clicked", self)

func take_damage(amount: int):
	_set_health(health - amount)

func _set_health(value: int):
	health = value
	health_bar.health = health
	if health <= 0:
		die()

func die():
	print("Zombie died!")
	zombie_died.emit(self)
	drop_random_item()
	queue_free()
	Global.player.gain_experience(8, true)

func drop_random_item():
	if !Global.turn_manager:
		return
	
	if droppable_items.is_empty():
		return
		
	var index = randi() % droppable_items.size()
	
	var item_scene = droppable_items[index]
	var item_instance = item_scene.instantiate()
	item_instance.global_position = $Marker2D.global_position
	get_parent().add_child(item_instance)

func take_action():
	if is_instance_valid(Global.player):
		attack()

func attack():
	print("Zombie attacks player for %d damage!" % attack_force)
	Global.player.suffer_damage(attack_force)
	
func _on_mouse_entered() -> void:
	zombie.modulate = Color(2,1,1,1)
	scale = Vector2(4.20,4.20)

func _on_mouse_exited() -> void:
	zombie.modulate = Color(1,1,1,1)
	scale = Vector2(4,4)
