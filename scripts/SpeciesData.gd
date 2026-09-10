class_name SpeciesData
extends RefCounted

var id: String
var name: String
var scientific_name: String

var population: int = 100

var habitat_preference: float = 70.0
var reproduction_rate: float = 0.05

var threat_level: float = 0.0


func _init(
	species_id: String,
	species_name: String,
	scientific: String,
	initial_population: int
):
	id = species_id
	name = species_name
	scientific_name = scientific
	population = initial_population
