extends Node2D

<<<<<<< HEAD
@onready var GameManager = $Controller/GameManager
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var turn : int = 1 
	GameManager.start_game()
	GameManager.next_turn()
=======

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var turn : int = 1 
>>>>>>> 3aa0d3c4ca204b5698e26b20c811511928a08178
	print(turn)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
