extends Node

const MONITOR_COST := 100
const RESTORE_COST := 300
const FIRE_COST := 200
const PROTECT_COST := 400


func monitor_species(
	position: Vector2i
) -> bool:

	if not ResourceManager.spend(
		MONITOR_COST
	):

		MessageManager.show_message(
			"Recursos insuficientes",
			"Você precisa de 100 recursos."
		)

		return false

	var cell = MapManager.get_cell(
		position
	)

	if cell == null:
		return false

	for species_id in cell.species:

		var animal = SpeciesManager.get_species(
			species_id
		)

		if animal != null:

			animal.threat_level = max(
				animal.threat_level - 10.0,
				0.0
			)

	MessageManager.show_notification(
		"🔎 Região monitorada."
	)

	return true


func restore_habitat(
	position: Vector2i
) -> bool:

	if not ResourceManager.spend(
		RESTORE_COST
	):

		MessageManager.show_message(
			"Recursos insuficientes",
			"Você precisa de 300 recursos."
		)

		return false

	MapManager.restore_habitat(
		position,
		20.0
	)

	MessageManager.show_notification(
		"🌱 Habitat recuperado!"
	)

	return true


func combat_fire(
	position: Vector2i
) -> bool:

	if not ResourceManager.spend(
		FIRE_COST
	):

		MessageManager.show_message(
			"Recursos insuficientes",
			"Você precisa de 200 recursos."
		)

		return false

	MapManager.remove_fire(
		position
	)

	MessageManager.show_notification(
		"🔥 Incêndio controlado!"
	)

	return true


func protect_area(
	position: Vector2i
) -> bool:

	if not ResourceManager.spend(
		PROTECT_COST
	):

		MessageManager.show_message(
			"Recursos insuficientes",
			"Você precisa de 400 recursos."
		)

		return false

	MapManager.protect_area(
		position
	)

	MessageManager.show_message(
		"🛡️ Área protegida",
		"Esta região agora está protegida."
	)

	return true
