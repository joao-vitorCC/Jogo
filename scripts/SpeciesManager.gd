
extends Node

signal population_changed(species_id, population)
signal species_critical(species_id)

var species: Dictionary = {}


func create_species():

	species.clear()

	add_species(
		SpeciesData.new(
			"lobo_guara",
			"Lobo-guará",
			"Chrysocyon brachyurus",
			100
		)
	)

	add_species(
		SpeciesData.new(
			"anta",
			"Anta",
			"Tapirus terrestris",
			90
		)
	)

	add_species(
		SpeciesData.new(
			"veado",
			"Veado-campeiro",
			"Ozotoceros bezoarticus",
			70
		)
	)

	add_species(
		SpeciesData.new(
			"onca",
			"Onça-pintada",
			"Panthera onca",
			100
		)
	)

	add_species(
		SpeciesData.new(
			"cao",
			"Cao-vinagre",
			"Speothos venaticus",
			120
		)
	)
	print(species)


func add_species(data: SpeciesData):

	species[data.id] = data


func get_species(species_id: String):

	return species.get(species_id)


func get_all_species() -> Array:

	return species.values()


func update_population(
	species_id: String,
	habitat_quality: float
):

	var animal: SpeciesData = get_species(species_id)

	if animal == null:
		return

	var habitat_factor := (
		habitat_quality - 50.0
	) / 100.0

	var change := (
		animal.population
		* animal.reproduction_rate
		* habitat_factor
	)

	animal.population += int(change)

	animal.population = max(
		animal.population,
		0
	)

	population_changed.emit(
		species_id,
		animal.population
	)

	if is_species_critical(species_id):

		species_critical.emit(species_id)


func update_all_populations():

	for animal in species.values():

		update_population(
			animal.id,
			animal.habitat_preference
		)


func reduce_population(
	species_id: String,
	percentage: float
):

	var animal: SpeciesData = get_species(species_id)

	if animal == null:
		return

	animal.population *= (
		1.0 - percentage
	)

	animal.population = max(
		animal.population,
		0
	)

	population_changed.emit(
		species_id,
		animal.population
	)


func is_species_critical(
	species_id: String
) -> bool:

	var animal: SpeciesData = get_species(species_id)

	if animal == null:
		return false

	return animal.population <= 20
