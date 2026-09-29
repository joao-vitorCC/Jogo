extends Node

signal resources_changed(new_amount)

const INITIAL_RESOURCES := 1000

var resources: int = INITIAL_RESOURCES


func reset():
	resources = INITIAL_RESOURCES
	print("resources: ",resources)
	resources_changed.emit(resources)


func can_spend(amount: int) -> bool:
	return resources >= amount


func spend(amount: int) -> bool:

	if not can_spend(amount):
		return false

	resources -= amount

	resources_changed.emit(resources)

	return true


func add_resources(amount: int):

	resources += amount

	resources_changed.emit(resources)


func get_resources() -> int:
	return resources
