
extends Node

signal turn_started(turn)
signal turn_ended(turn)
var turn : int = 1
var year : int
const MAX_TURNS := 10

func reset():
	turn = 1
	print("turno",turn)
	
func start_turn():
	turn_started.emit(turn)
	
func end_turn():
	turn_ended.emit(turn)
	turn += 1
	
func is_last_turn()->bool:
	return turn >= MAX_TURNS
	
func get_turn()->int:
	return turn
