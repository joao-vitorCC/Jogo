extends CanvasLayer

@onready var turn_label = $TurnLabel
@onready var resource_label = $ResourceLabel
@onready var biodiversity_label = $BiodiversityLabel

@onready var message_panel = $MessagePanel


func _ready():

	ResourceManager.resources_changed.connect(
		update_resources
	)

	EcosystemManager.biodiversity_changed.connect(
		update_biodiversity
	)

	MessageManager.message_requested.connect(
		show_message
	)

	update_interface()


func update_interface():

	update_turn(
		TurnManager.get_turn()
	)

	update_resources(
		ResourceManager.get_resources()
	)

	update_biodiversity(
		EcosystemManager.get_biodiversity()
	)


func update_turn(turn: int):

	turn_label.text = (
		"Ano: " + str(turn)
	)


func update_resources(resources: int):

	resource_label.text = (
		"Recursos: " + str(resources)
	)


func update_biodiversity(value: float):

	biodiversity_label.text = (
		"Biodiversidade: "
		+ str(round(value))
		+ "%"
	)


func show_message(
	title: String,
	message: String
):

	message_panel.show_message(
		title,
		message
	)
