extends Node2D  # Comece com o tipo de nó correto (Node2D, Control, etc.)

# Referência aos painéis
@onready var health_bar_background = $Panel  # Barra de fundo
@onready var health_bar = $Panel/Panel  # Barra de vida

# A vida máxima e a vida atual do personagem
var max_health = 100
var current_health = 100

func _ready() -> void:
	take_damage(50)

# Função para atualizar a barra de vida
func update_health():
	var health_percentage = current_health / max_health
	health_bar.size.x = health_bar_background.size.x * health_percentage

# Função para reduzir a vida (exemplo de como tomar dano)
func take_damage(damage):
	current_health -= damage
	if current_health < 0:
		current_health = 0
	update_health()

# Função para curar o personagem
func heal(amount):
	current_health += amount
	if current_health > max_health:
		current_health = max_health
	update_health()

func is_alive() -> bool:
	return current_health > 0
