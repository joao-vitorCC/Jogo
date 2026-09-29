extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventManager.event.connect(_on_fire)

func _on_fire():
	$".".play("incendio")
