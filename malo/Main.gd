extends Node2D

@onready var jugador: Jugador = $Jugador
@onready var moho: Enemigo = $Enemigo
@onready var mov = $Jugador/Movimiento  
@onready var video_game_over = $VideoGameOver 

func _input(event: InputEvent) -> void:
	if not (event is InputEventKey and event.pressed and not event.echo):
		return
	match event.keycode:
		KEY_SPACE:
			if mov.esta_vivo():
				mov.reproducir_ataque()  
				var distancia = jugador.position.distance_to(moho.position)
				if moho.vida > 0 and distancia <= 270.0: 
					jugador.atacar(moho)
		KEY_R:
			moho.reiniciar()
			mov.reiniciar()
			video_game_over.stop()
			video_game_over.hide()
			
			
			
		KEY_1:
			if jugador.monedas >= 15:
				jugador.monedas -= 15
				jugador.tiene_metal = true
		KEY_2:
			if jugador.monedas >= 10:
				jugador.monedas -= 10
				jugador.tiene_jabon = true
		KEY_3:
			if jugador.monedas >= 20:
				jugador.monedas -= 20
				jugador.tiene_cloro = true

func _ready() -> void:
	
	mov.jugador_murio.connect(_mostrar_game_over)
	
func _mostrar_game_over() -> void:
	video_game_over.show()
	video_game_over.play()

func _on_video_game_over_finished() -> void:
	video_game_over.hide()
	
	
	
