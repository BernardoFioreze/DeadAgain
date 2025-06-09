extends CharacterBody2D
class_name Zombie

@onready var health_bar = $HealthBar
@onready var zombie = $ZombieAnimatedSprite

@export var attack_force: int
@export var health : int

signal clicked(zombie)
signal zombie_died(zombie)

var granade = preload("res://Scenes/Collectables/granade_collectable.tscn")

func _ready() -> void:
	health_bar.init_health(health)

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
	drop_item()
	queue_free()

func drop_item():
	var granade_instance = granade.instantiate()
	granade_instance.global_position = $Marker2D.global_position
	get_parent().add_child(granade_instance)

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
