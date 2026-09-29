#extends Node

#@export var dialog_scene : PackedScene
#var dialog_box = null
#var isShowingDialog : bool = false

#func start_dialog(texts:Array[String],dialog_position : Vector2):
#	if isShowingDialog:
#		return
	
#	if dialog_scene:
#		dialog_box = dialog_scene.instantiate()
#		get_tree().current_scene.add_child(dialog_box)
		
#		dialog_box.textToDisplay = texts
#		dialog_box.global_position = dialog_position
#		dialog_box.showText()
#		isShowingDialog = true
		
#		dialog_box.dialog_finished.connect(_on_dialog_finished)
	
#func _on_dialog_finished():
#	isShowingDialog = false
#	if dialog_box:
#		dialog_box.queue_free()
#		dialog_box = null


extends Node

signal bt_recuperacao_clicada

@export var dialog_scene: PackedScene

var dialog_box = null
var isShowingDialog: bool = false


func start_dialog(texts: Array[String], dialog_position: Vector2):
	if isShowingDialog:
		return

	if dialog_scene:
		dialog_box = dialog_scene.instantiate()
		get_tree().current_scene.add_child(dialog_box)

		dialog_box.textToDisplay = texts
		dialog_box.global_position = dialog_position
		dialog_box.showText()

		isShowingDialog = true

		dialog_box.dialog_finished.connect(_on_dialog_finished)
		dialog_box.recuperacao_clicada.connect(_on_recuperacao_clicada)
		# Conecta o botão da cena recém-instanciada
#		var botao = dialog_box.get_node("RecuperacaoTotal")
#		botao.pressed.connect(_on_recuperacao_clicada)


func _on_recuperacao_clicada():
	bt_recuperacao_clicada.emit()


func _on_dialog_finished():
	isShowingDialog = false

	if dialog_box:
		dialog_box.queue_free()
		dialog_box = null
