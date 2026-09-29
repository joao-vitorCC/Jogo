class_name GameManager
extends Node



signal game_started
signal game_finished
@onready var turn_manage = $TurnManager

var game_running := false


func start_game():

	ResourceManager.reset()

	TurnManager.reset()

	MapManager.create_grid()

	SpeciesManager.create_species()

	EcosystemManager.calculate_biodiversity()

	game_running = true

	TurnManager.start_turn()

	game_started.emit()


func next_turn():

	if not game_running:
		return

	TurnManager.end_turn()

	EventManager.generate_event()

	EcosystemManager.simulate_turn()

	check_game_state()

	if game_running:

		TurnManager.start_turn()


func check_game_state():

	if TurnManager.is_last_turn():

		end_game()

		return

	if EcosystemManager.get_biodiversity() <= 0:

		end_game()


func end_game():

	game_running = false

	var score := EcosystemManager.get_biodiversity()

	var title := ""
	var message := ""

	if score >= 80:

		title = "🏆 Excelente gestão!"

		message = (
			"Você conseguiu manter uma "
			+ "biodiversidade elevada."
		)

	elif score >= 50:

		title = "🌱 Gestão moderada"

		message = (
			"O ecossistema sobreviveu, "
			+ "mas existem problemas."
		)

	else:

		title = "⚠️ Ecossistema degradado"

		message = (
			"A biodiversidade sofreu "
			+ "grandes perdas."
		)

	MessageManager.show_message(
		title,
		message
	)

	game_finished.emit()
