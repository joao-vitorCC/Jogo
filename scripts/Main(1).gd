extends Node2D


func _ready():

	GameManager.start_game()

	print("FaunaBR iniciado!")


func _on_next_turn_button_pressed():

	GameManager.next_turn()


func _on_monitor_button_pressed():

	ActionManager.monitor_species(
		Vector2i(2, 2)
	)


func _on_restore_button_pressed():

	ActionManager.restore_habitat(
		Vector2i(2, 2)
	)


func _on_fire_button_pressed():

	ActionManager.combat_fire(
		Vector2i(2, 2)
	)


func _on_protect_button_pressed():

	ActionManager.protect_area(
		Vector2i(2, 2)
	)
