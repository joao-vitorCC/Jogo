extends MarginContainer
signal dialog_finished()
var textToDisplay : Array[String] = []
var currentIndex : int = 0 
var typingSpeed : float =0.5
var isTyping : bool = false

@onready var textLabel = $textContainer/textLabel
@onready var tween  : Tween = get_tree().create_tween()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pivot_offset = size/2
	self.scale = Vector2.ZERO
	
	tween.tween_property(self,"scale",Vector2.ONE,0.3).set_trans(Tween.TRANS_BACK)
	if textToDisplay.size() > 0:
		showText()

func showText():
	if currentIndex < textToDisplay.size():
		isTyping = true
		textLabel.text = ""
		_type_text(textToDisplay[currentIndex])
	else:
		_close_dialog()
		
func _type_text(text:String):
	for i in range(text.length()):
		textLabel.text += text[i]
		await get_tree().create_timer(typingSpeed).timeout
		
	isTyping = false
	get_tree().paused = true
	
func _close_dialog():
	isTyping = true
	tween = get_tree().create_tween()
	tween.tween_property(self,"scale",Vector2.ZERO,0.3).set_trans(Tween.TRANS_BACK)
	await tween.finished
	dialog_finished.emit()
	queue_free()
	
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and not isTyping:
		if isTyping:
			textLabel.text = textToDisplay[currentIndex]
			isTyping = false
		else:
			get_tree().paused = false
			_close_dialog()
