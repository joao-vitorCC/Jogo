extends Node

@export var dialog_scene : PackedScene
var dialog_box = null
var isShowingDialog : bool = false

func start_dialog(texts:Array[String],dialog_position : Vector2):
	if isShowingDialog:
		return
	
	if dialog_scene:
		dialog_box = dialog_scene.instantiate()
		get_tree().current_scene.add_child(dialog_box)
		
		dialog_box.texts_to_display = texts
		dialog_box.global_position = dialog_position
		dialog_box.show_text()
		isShowingDialog = true
		
		dialog_box.dialog_finished.connect(_on_dialog_finished)
	
func _on_dialog_finished():
	isShowingDialog = false
	if dialog_box:
		dialog_box.queue_free()
		dialog_box = null
		
