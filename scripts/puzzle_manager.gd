extends Node2D
@export var dialog_scene: PackedScene
var puzzle = null
signal rec_total
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DialogManager.bt_recuperacao_clicada.connect(_on_bt_rec)

func _on_bt_rec():
	#print("test")
	if dialog_scene:
		puzzle = dialog_scene.instantiate()
		get_tree().current_scene.add_child(puzzle)
		puzzle.global_position = $".".global_position
		puzzle.puzzle_completed_signal.connect(_on_completed_puzzle)
		
func _on_completed_puzzle():
	rec_total.emit()
	puzzle.queue_free()
	puzzle = null
