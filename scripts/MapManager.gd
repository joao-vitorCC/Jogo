
extends Node

signal cell_changed(position)
const WIDTH := 10
const HEIGHT := 8
var grid: Array = []
@onready var GameManager = $GameManager

func create_grid():
	grid.clear()
	for y in range(HEIGHT):
		var row : Array = []
		for x in range(WIDTH):
			var cell := CellData.new(Vector2i(x,y))
			row.append(cell)
		grid.append(row)
		
func is_valid_cell(position: Vector2i)->bool:
	return(position.x >= 0 and position.x < WIDTH and position.y >= 0 and position.y < HEIGHT)
	
func get_cell(position: Vector2i):
	if not is_valid_cell(position):
		return null
	return grid[position.y][position.x]
	
func get_neighbors(position: Vector2i)-> Array:
	var neighbors: Array = []
	var directions := [Vector2i.UP,Vector2i.DOWN,Vector2i.LEFT,Vector2i.RIGHT]
	for direction in directions:
		var neighbor_position = position + direction
		if is_valid_cell(neighbor_position):
			neighbors.append(get_cell(neighbor_position))
	return neighbors

func damage_habitat(position: Vector2i, amount: float):
	var cell = get_cell(position)
	if cell == null:
		return
	cell.damage_habitat(amount)
	cell_changed.emit(position)

func restore_habitat(position: Vector2i,amount: float):
	var cell = get_cell(position)
	if cell == null:
		return
	cell.restore_habitat(amount)
	cell_changed.emit(position)

func set_fire(position: Vector2i):
	var cell = get_cell(position)
	if cell == null:
		return
	cell.on_fire = true
	cell.damage_habitat(20)
	cell_changed.emit(position)
	
func protected_area(position: Vector2i):
	var cell = get_cell(position)
	if cell == null:
		return
	cell.protected_area = true
	cell_changed.emit(position)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
