extends Node2D

@export var cena_obstaculo: PackedScene
@export var velocidade_inicial: float = 350.0
@export var aceleracao: float = 8.0

@onready var hud_game_over: Panel = $HUD/game_over

@onready var spawn_timer: Timer = $spawn_timer
@onready var spawn_position: Marker2D = $spawn_position

@onready var restart_button: Button = $HUD/game_over/restart_button
@onready var game_over_sfx: AudioStreamPlayer = $HUD/game_over/game_over_sfx

@onready var score: Label = $HUD/score

var pontos: float = 0.0
var jogo_ativo: bool = true

func _ready() -> void:
	hud_game_over.visible = false
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	
	restart_button.pressed.connect(_on_botao_reiniciar_pressed)

func _process(delta: float) -> void:
	if not jogo_ativo:
		return

	pontos += delta * 10.0
	score.text = "Pontos: %d" % int(pontos)

func _on_spawn_timer_timeout() -> void:
	if not jogo_ativo or cena_obstaculo == null:
		return

	var obstaculo = cena_obstaculo.instantiate()
	obstaculo.position = spawn_position.position
	obstaculo.velocidade = velocidade_inicial + (pontos * aceleracao * 0.1)
	obstaculo.body_entered.connect(_on_obstaculo_body_entered)
	add_child(obstaculo)

func _on_obstaculo_body_entered(body: Node2D) -> void:
	if body.name == "Player" and jogo_ativo:
		jogo_ativo = false
		spawn_timer.stop()
		if has_node("SomGameOver"):
			game_over_sfx.play()
		hud_game_over.visible = true

func _on_botao_reiniciar_pressed() -> void:
	get_tree().reload_current_scene()
