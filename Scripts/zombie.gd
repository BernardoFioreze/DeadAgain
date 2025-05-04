extends CharacterBody2D

@onready var health_bar = $HealthBar
@onready var zombie = $ZombieAnimatedSprite

@export var dropped_item: InvItem
var player = null

var granade = preload("res://Scenes/Collectables/granade_collectable.tscn")

var health
var turnos
var attack_force

func _ready() -> void:
	turnos = 1
	health = 100
	health_bar.init_health(health)

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		print("Zombie")
		_set_health(health - 25)
		if health <= 0:
			die()
		
func _on_mouse_entered() -> void:
	zombie.modulate = Color(2,1,1,1)
	scale = Vector2(1.05,1.05)

func _on_mouse_exited() -> void:
	zombie.modulate = Color(1,1,1,1)
	scale = Vector2(1,1)
	
func _set_health(value):
	health = value
	health_bar.health = health
	
func _get_attack_force():
	return 
	
func die():
	drop_item()
	queue_free()
	
func drop_item():
	var granade_instance = granade.instantiate()
	granade_instance.global_position = $Marker2D.global_position
	get_parent().add_child(granade_instance)
	await get_tree().create_timer(0.0).timeout
	
