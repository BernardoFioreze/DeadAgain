extends CharacterBody2D

@export var inventory: Inv

@onready var health_bar = $HealthBar
@onready var rick = $Rick

var health
var turnos
var jogadas
var attack_force

func _ready() -> void:
	Global.player = self
	turnos = 1
	health = 100
	attack_force = 25
	health_bar.init_health(health)

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
	
