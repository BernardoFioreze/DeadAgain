extends CharacterBody2D
class_name Zombie

@onready var health_bar = $HealthBar
@onready var zombie = $ZombieAnimatedSprite

@export var attack_force: int
@export var health : int
@export var is_boss: bool

signal clicked(zombie)
signal zombie_died(zombie)

var is_dying: bool

var droppable_items: Array = [
	preload("res://Scenes/Collectables/sniperCase_collectable.tscn"),
	preload("res://Scenes/Collectables/shotgunCase_collectable.tscn"),
	preload("res://Scenes/Collectables/gunpowder_collectable.tscn"),
	preload("res://Scenes/Collectables/flask_collectable.tscn"),
	preload("res://Scenes/Collectables/herb_collectable.tscn"),
	preload("res://Scenes/Collectables/metalScrap_collectable.tscn")
]

func _ready() -> void:
	health_bar.init_health(health)
	is_dying = false
	if is_boss:
		droppable_items.clear()
		droppable_items.append(preload("res://Scenes/Collectables/rpgAmmo_collectable.tscn"))		
		droppable_items.append(preload("res://Scenes/Collectables/sniperAmmo_collectable.tscn"))
		droppable_items.append(preload("res://Scenes/Collectables/shotgunAmmo_collectable.tscn"))
		droppable_items.append(preload("res://Scenes/Collectables/medkit_collectable.tscn"))

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and not is_dying: 
		emit_signal("clicked", self)

func take_damage(amount: int):
	_set_health(health - amount)

func _set_health(value: int):
	if not is_dying:
		health = value
		health_bar.health = health
		if health <= 0:
			die()

func die():
	zombie_died.emit(self)
	health_bar.visible = false
	is_dying = true
	drop_random_item()
	Global.player.gain_experience(8, true)
	Input.set_custom_mouse_cursor(null, Input.CURSOR_ARROW)
	zombie.play("die")
	await get_tree().create_timer(0.95).timeout 
	queue_free()

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
	if is_instance_valid(Global.player) and not is_dying:
		zombie.modulate = Color(1.5, 1.5, 0.5, 1)
		attack()
		
func paint_back():
	zombie.modulate = Color(1, 1, 1, 1)

func attack():
	Global.player.suffer_damage(attack_force)
	
func _on_mouse_entered() -> void:
	if is_dying:
		return
	zombie.modulate = Color(2,1,1,1)
	scale = Vector2(4.20,4.20)
	
	var inv = Global.player.inventory
	
	var cursor_image : Texture2D
	if inv.get_selected_item() != null && inv.get_selected_item().is_attack_item():
		cursor_image = inv.get_selected_item().texture
	else:
		cursor_image = preload("res://Assets/Cursor/blocked_action.png")
		
	Input.set_custom_mouse_cursor(cursor_image, Input.CURSOR_ARROW)
		
func _on_mouse_exited() -> void:
	if is_dying:
		return
	zombie.modulate = Color(1,1,1,1)
	scale = Vector2(4,4)
	Input.set_custom_mouse_cursor(null, Input.CURSOR_ARROW)
