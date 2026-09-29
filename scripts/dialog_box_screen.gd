extends Node2D
@export var textToDisplay : Array[String] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventManager.event.connect(_on_does_event)

func _on_does_event():
	DialogManager.start_dialog(textToDisplay,$".".global_position)
	await get_tree().create_timer(10).timeout
	DialogManager._on_dialog_finished()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
