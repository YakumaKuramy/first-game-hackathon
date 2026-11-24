extends Node2D

@export var cena_obstaculo: PackedScene
@export var velocidade_inicial: float = 350.0
@export var aceleracao: float = 8.0

var pontos: float = 0.0
var jogo_ativo: bool = true

func _ready() -> void:
	$CanvasLayer/TelaGameOver.visible = false
	$SpawnTimer.timeout.connect(_on_spawn_timer_timeout)
	$CanvasLayer/TelaGameOver/BotaoReiniciar.pressed.connect(_on_botao_reiniciar_pressed)

func _process(delta: float) -> void:
	if not jogo_ativo:
		return

	pontos += delta * 10.0
	$CanvasLayer/LabelPontuacao.text = "Pontos: %d" % int(pontos)

func _on_spawn_timer_timeout() -> void:
	if not jogo_ativo or cena_obstaculo == null:
		return

	var obstaculo = cena_obstaculo.instantiate()
	obstaculo.position = $PontoSpawn.position
	obstaculo.velocidade = velocidade_inicial + (pontos * aceleracao * 0.1)
	obstaculo.body_entered.connect(_on_obstaculo_body_entered)
	add_child(obstaculo)

func _on_obstaculo_body_entered(body: Node2D) -> void:
	if body.name == "Player" and jogo_ativo:
		jogo_ativo = false
		$SpawnTimer.stop()
		if has_node("SomGameOver"):
			$SomGameOver.play()
		$CanvasLayer/TelaGameOver.visible = true

func _on_botao_reiniciar_pressed() -> void:
	get_tree().reload_current_scene()
