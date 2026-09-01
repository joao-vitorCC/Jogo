extends Node

var random := RandomNumberGenerator.new()


func generate_event():

	random.randomize()

	var event_id := random.randi_range(
		0,
		3
	)

	match event_id:

		0:
			fire_event()

		1:
			drought_event()

		2:
			deforestation_event()

		3:
			recovery_event()


func fire_event():

	var position := Vector2i(
		random.randi_range(
			0,
			MapManager.WIDTH - 1
		),
		random.randi_range(
			0,
			MapManager.HEIGHT - 1
		)
	)

	MapManager.set_fire(position)

	MessageManager.show_message(
		"🔥 Incêndio",
		"Um incêndio foi detectado no mapa."
	)


func drought_event():

	MessageManager.show_message(
		"☀️ Período de seca",
		"A disponibilidade de água diminuiu."
	)

	for y in range(MapManager.HEIGHT):

		for x in range(MapManager.WIDTH):

			var cell = MapManager.get_cell(
				Vector2i(x, y)
			)

			cell.water_level = max(
				cell.water_level - 15,
				0
			)


func deforestation_event():

	var position := Vector2i(
		random.randi_range(
			0,
			MapManager.WIDTH - 1
		),
		random.randi_range(
			0,
			MapManager.HEIGHT - 1
		)
	)

	MapManager.damage_habitat(
		position,
		20
	)

	MessageManager.show_message(
		"🌳 Desmatamento",
		"Uma área sofreu perda de vegetação."
	)


func recovery_event():

	var position := Vector2i(
		random.randi_range(
			0,
			MapManager.WIDTH - 1
		),
		random.randi_range(
			0,
			MapManager.HEIGHT - 1
		)
	)

	MapManager.restore_habitat(
		position,
		10
	)

	MessageManager.show_message(
		"🌱 Recuperação natural",
		"Uma região apresentou recuperação ambiental."
	)
