<<<<<<< HEAD

=======
class_name TurnManager
>>>>>>> 3aa0d3c4ca204b5698e26b20c811511928a08178
extends Node

signal turn_started(turn)
signal turn_ended(turn)
var turn : int = 1
var year : int
const MAX_TURNS := 10

func reset():
	turn = 1
<<<<<<< HEAD
	print("turno",turn)
	
=======

>>>>>>> 3aa0d3c4ca204b5698e26b20c811511928a08178
func start_turn():
	turn_started.emit(turn)
	
func end_turn():
	turn_ended.emit(turn)
	turn += 1
	
func is_last_turn()->bool:
	return turn >= MAX_TURNS
	
func get_turn()->int:
	return turn
<<<<<<< HEAD
=======

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
>>>>>>> 3aa0d3c4ca204b5698e26b20c811511928a08178
