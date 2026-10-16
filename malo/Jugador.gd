class_name Jugador
extends Node2D

var monedas := 0
var tiene_metal := false
var tiene_jabon := false
var tiene_cloro := false


func descripcion() -> String:
	var s := "Cubeta"
	if tiene_metal: s += " + Metal"
	if tiene_jabon: s += " + Jabon"
	if tiene_cloro: s += " + Cloro"
	return s


func calcular_dano() -> int:
	var d := 10
	if tiene_metal: d += 15
	if tiene_jabon: d += 10
	if tiene_cloro: d += 20
	return d


func atacar(enemigo: Enemigo) -> void:
	var d := calcular_dano()
	print("%s = %d de dano" % [descripcion(), d])
	enemigo.recibir_dano(d)
	monedas += 5
