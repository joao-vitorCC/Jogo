extends Node

signal message_requested(title, message)
signal notification_requested(message)


func show_message(
	title: String,
	message: String
):

	message_requested.emit(
		title,
		message
	)


func show_notification(
	message: String
):

	notification_requested.emit(
		message
	)
