class_name CellData
extends RefCounted

var position: Vector2i
var terrain: String = "forest"

var habitat_quality: float = 100.0
var water_level: float = 100.0
var pollution: float = 0.0

var on_fire: bool = false
var protected_area: bool = false

var species: Array[String] = []


func _init(cell_position: Vector2i):
	position = cell_position


func damage_habitat(amount: float):
	habitat_quality = clamp(
		habitat_quality - amount,
		0.0,
		100.0
	)


func restore_habitat(amount: float):
	habitat_quality = clamp(
		habitat_quality + amount,
		0.0,
		100.0
	)
