extends CharacterBody2D

@export var forca_pulo: float = -520.0
@export var gravidade: float = 1400.0

func _physics_process(delta: float) -> void:
	# Aplica gravidade quando o jogador não está no chão
	if not is_on_floor():
		velocity.y += gravidade * delta

	# Executa o pulo ao pressionar Espaço/Enter estando no chão
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = forca_pulo
		if has_node("SomPulo"):
			$SomPulo.play()

	move_and_slide()
