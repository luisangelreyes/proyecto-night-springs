extends Node

@export var velocidad: float = 200.0
@export var vida_max: int = 100
@export var x_min: float = 0.0
@export var x_max: float = 1152.0

signal jugador_murio

var vida: int
var _cuerpo: Node2D
var _sprite: AnimatedSprite2D
var _atacando: bool = false
var _herido: bool = false
var _muerto: bool = false


func _ready() -> void:
	vida = vida_max
	_cuerpo = get_parent() as Node2D
	_sprite = get_parent() as AnimatedSprite2D
	if _sprite:
		_sprite.animation_finished.connect(_on_animacion_terminada)
		_reproducir("idle")


func _process(delta: float) -> void:
	if _muerto or _atacando or _herido:
		return
	var direccion := Input.get_axis("ui_left", "ui_right")
	_cuerpo.position.x = clampf(_cuerpo.position.x + direccion * velocidad * delta, x_min, x_max)
	if _sprite and direccion != 0:
		_sprite.flip_h = direccion < 0
	_reproducir("walk" if direccion != 0 else "idle")


func esta_vivo() -> bool:
	return not _muerto


func reproducir_ataque() -> void:
	if _muerto or _herido:
		return
	if _tiene_animacion("attack"):
		_atacando = true
		_sprite.play("attack")


func recibir_dano(cantidad: int) -> void:
	if _muerto:
		return
	vida -= cantidad
	print(">> Conserje: vida %d/%d" % [max(vida, 0), vida_max])
	if vida <= 0:
		_muerto = true
		_atacando = false
		_herido = false
		print(">> El conserje cayo! (R para reiniciar)")
		_reproducir("death")
		
		
	elif _tiene_animacion("damage"): # Quitamos el "and not _atacando"
		_herido = true
		_atacando = false # Cancelamos el estado de ataque
		_sprite.play("damage")


func reiniciar() -> void:
	vida = vida_max
	_muerto = false
	_atacando = false
	_herido = false
	_reproducir("idle")


func _on_animacion_terminada() -> void:
	match _sprite.animation:
		"attack":
			_atacando = false
		"damage":
			_herido = false
		"death":
			jugador_murio.emit()


func _tiene_animacion(nombre: String) -> bool:
	return _sprite != null and _sprite.sprite_frames != null \
		and _sprite.sprite_frames.has_animation(nombre)


func _reproducir(nombre: String) -> void:
	if _tiene_animacion(nombre):
		_sprite.play(nombre)
