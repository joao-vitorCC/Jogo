<<<<<<< HEAD

=======
>>>>>>> 3aa0d3c4ca204b5698e26b20c811511928a08178
extends Node

signal biodiversity_changed(value)

var biodiversity: float = 100.0


func calculate_biodiversity() -> float:

	var all_species = SpeciesManager.get_all_species()

	if all_species.is_empty():
		return 0.0

	var total := 0.0

	for animal in all_species:

		total += clamp(
			float(animal.population),
			0.0,
			100.0
		)

	biodiversity = total / all_species.size()

	biodiversity_changed.emit(
		biodiversity
	)
<<<<<<< HEAD
	print("bio ",biodiversity)
=======

>>>>>>> 3aa0d3c4ca204b5698e26b20c811511928a08178
	return biodiversity


func simulate_turn():

	SpeciesManager.update_all_populations()

	calculate_biodiversity()


func get_biodiversity() -> float:

	return biodiversity
