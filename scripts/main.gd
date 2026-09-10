extends Node2D

@onready var GameManager = $Controller/GameManager
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var turn : int = 1 
	GameManager.start_game()
	GameManager.next_turn()
	print(turn)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
