extends Area2D

@export var velocidade: float = 350.0

func _physics_process(delta: float) -> void:
	position.x -= velocidade * delta

	# Libera da memória quando sair da tela à esquerda
	if position.x < -100.0:
		queue_free()
