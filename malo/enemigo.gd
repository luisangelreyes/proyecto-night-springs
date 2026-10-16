class_name Enemigo
extends AnimatedSprite2D

var vida := 300.0
var regeneracion := 12.0  
var _jugador: Node2D
var _mov: Node  
var _inicio: Vector2
var _tiempo := 0.0


func _ready() -> void:
	_inicio = position
	_jugador = get_parent().get_node("Jugador")
	_mov = _jugador.get_node("Movimiento")
	play("idle")

func _process(delta: float) -> void:
	if vida <= 0 or not _mov.esta_vivo():
		return
	vida = min(vida + regeneracion * delta, 300.0)
	var dx := _jugador.position.x - position.x
	if absf(dx) > 256.0:
		position.x += signf(dx) * 60.0 * delta
	else:
		_tiempo += delta
		if _tiempo >= 2.0:
			_tiempo = 0.0
			print("!Moho ataca al conserje!")
			_mov.recibir_dano(10)


func recibir_dano(cantidad: int) -> void:
	vida -= cantidad
	print("  Moho: vida restante %d" % max(vida, 0))
	if vida <= 0:
		print("  Moho eliminado!")
		hide()
	


func reiniciar() -> void:
	vida = 300.0
	position = _inicio
