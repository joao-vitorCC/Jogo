extends Control

# ============================================================
# PUZZLE V3
# ============================================================
#
# - Imagem dividida em peças
# - Alta qualidade usando AtlasTexture
# - Drag and Drop
# - Troca de peças ao soltar
# - Embaralhamento
# - Detecção automática
# - Botão de reiniciar
# - Animação de conclusão
#
# ============================================================


# ============================================================
# CONFIGURAÇÕES
# ============================================================

@export_category("Imagem")

@export var puzzle_texture: Texture2D


@export_category("Grade")

@export_range(2, 12, 1)
var columns: int = 4

@export_range(2, 12, 1)
var rows: int = 3


@export_category("Tamanho do tabuleiro")

@export var board_size: Vector2 = Vector2(800, 600)


@export_category("Embaralhamento")

@export_range(1, 500, 1)
var shuffle_moves: int = 100


@export_category("Visual")

@export var show_piece_borders: bool = true

@export var border_color: Color = Color(0.05, 0.05, 0.05, 0.8)

@export_range(0.0, 10.0, 0.5)
var border_width: float = 2.0


# ============================================================
# VARIÁVEIS
# ============================================================

var pieces: Array[PuzzlePiece] = []

var piece_width: float
var piece_height: float

var solved: bool = false
signal puzzle_completed_signal

# ============================================================
# READY
# ============================================================

func _ready() -> void:

	$Board.size = board_size

	# Botão de reiniciar
	if has_node("RestartButton"):

		$RestartButton.pressed.connect(
			restart_puzzle
		)

	# Esconde mensagem inicialmente
	if has_node("CompletedLabel"):

		$CompletedLabel.visible = false

	# Cria o puzzle
	create_puzzle()


# ============================================================
# CRIA PUZZLE
# ============================================================

func create_puzzle() -> void:

	clear_puzzle()

	solved = false

	if has_node("CompletedLabel"):

		$CompletedLabel.visible = false


	if puzzle_texture == null:

		push_error(
			"Nenhuma imagem foi definida em Puzzle Texture."
		)

		return


	# ========================================================
	# TAMANHO DAS PEÇAS
	# ========================================================

	piece_width = (
		board_size.x / float(columns)
	)

	piece_height = (
		board_size.y / float(rows)
	)


	# ========================================================
	# CRIA PEÇAS
	# ========================================================

	for y in range(rows):

		for x in range(columns):

			var piece := PuzzlePiece.new()


			piece.name = (
				"Piece_%d_%d"
				% [x, y]
			)


			piece.original_x = x

			piece.original_y = y


			piece.correct_position = (
				y * columns + x
			)


			piece.current_position = (
				piece.correct_position
			)


			piece.piece_size = Vector2(
				piece_width,
				piece_height
			)


			piece.setup_piece(

				puzzle_texture,

				x,
				y,

				columns,
				rows,

				piece_width,
				piece_height,

				show_piece_borders,

				border_color,

				border_width
			)


			piece.puzzle = self


			# Posição original
			piece.position = Vector2(

				x * piece_width,

				y * piece_height
			)


			$Board.add_child(piece)

			pieces.append(piece)


	# Embaralha
	shuffle_puzzle()
	create_board_border()


# ============================================================
# LIMPA PUZZLE
# ============================================================

func clear_puzzle() -> void:

	for piece in pieces:

		if is_instance_valid(piece):

			piece.queue_free()


	pieces.clear()


# ============================================================
# EMBARALHAR
# ============================================================

func shuffle_puzzle() -> void:

	if pieces.size() <= 1:

		return


	var rng := RandomNumberGenerator.new()

	rng.randomize()


	for i in range(shuffle_moves):

		var index_a := rng.randi_range(
			0,
			pieces.size() - 1
		)


		var index_b := rng.randi_range(
			0,
			pieces.size() - 1
		)


		if index_a == index_b:

			continue


		swap_pieces(
			index_a,
			index_b,
			false
		)


# ============================================================
# TROCA PEÇAS
# ============================================================

func swap_pieces(
	index_a: int,
	index_b: int,
	check: bool = true
) -> void:

	if index_a == index_b:

		return


	var piece_a := pieces[index_a]

	var piece_b := pieces[index_b]


	# Guarda posições
	var position_a := piece_a.position

	var position_b := piece_b.position


	# Troca no array
	pieces[index_a] = piece_b

	pieces[index_b] = piece_a


	# Atualiza posição lógica
	piece_a.current_position = index_b

	piece_b.current_position = index_a


	# Troca visual
	piece_a.position = position_b

	piece_b.position = position_a


	if check:

		check_solution()


# ============================================================
# COMEÇOU A ARRASTAR
# ============================================================

func piece_started_dragging(
	piece: PuzzlePiece
) -> void:

	piece.z_index = 100


	piece.modulate = Color(
		1.0,
		1.0,
		1.0,
		0.85
	)


	piece.scale = Vector2(
		1.04,
		1.04
	)


# ============================================================
# TERMINOU O ARRASTE
# ============================================================

func piece_finished_dragging(
	piece: PuzzlePiece
) -> void:

	piece.z_index = 0

	piece.modulate = Color.WHITE

	piece.scale = Vector2.ONE


# ============================================================
# DROP
# ============================================================

func drop_piece(
	dragged_piece: PuzzlePiece,
	target_piece: PuzzlePiece
) -> void:

	if solved:

		return


	if dragged_piece == target_piece:

		return


	var dragged_index := pieces.find(
		dragged_piece
	)


	var target_index := pieces.find(
		target_piece
	)


	if dragged_index == -1:

		return


	if target_index == -1:

		return


	# Troca
	swap_pieces(
		dragged_index,
		target_index,
		true
	)


# ============================================================
# VERIFICA SOLUÇÃO
# ============================================================

func check_solution() -> void:

	if solved:

		return


	for i in range(pieces.size()):

		var piece := pieces[i]


		if piece.correct_position != i:

			return


	# Tudo correto
	solved = true


	puzzle_completed()


# ============================================================
# PUZZLE COMPLETO
# ============================================================

func puzzle_completed() -> void:

	print(
		"Puzzle concluído!"
	)


	if has_node("CompletedLabel"):

		$CompletedLabel.text = (
			"PUZZLE CONCLUÍDO!"
		)

		$CompletedLabel.visible = true


	# Animação
	for piece in pieces:

		var tween := create_tween()

		tween.tween_property(

			piece,

			"scale",

			Vector2(
				1.03,
				1.03
			),

			0.12
		)


		tween.tween_property(

			piece,

			"scale",

			Vector2.ONE,

			0.12
		)
	puzzle_completed_signal.emit()
	# ========================================================
	# COLOQUE AQUI O QUE ACONTECE DEPOIS
	# ========================================================

	# Exemplo:
	#
	# get_tree().change_scene_to_file(
	#     "res://proxima_fase.tscn"
	# )

# ============================================================
# REINICIAR
# ============================================================

func restart_puzzle() -> void:

	create_puzzle()


# ============================================================
# CLASSE DA PEÇA
# ============================================================

class PuzzlePiece extends Control:

	var puzzle: Control

	var texture: Texture2D

	var original_x: int
	var original_y: int

	var correct_position: int
	var current_position: int

	var piece_size: Vector2

	var dragging: bool = false

	var texture_rect: TextureRect


	# ========================================================
	# CONFIGURA A PEÇA
	# ========================================================

	func setup_piece(

		source_texture: Texture2D,

		x: int,
		y: int,

		total_columns: int,
		total_rows: int,

		width: float,
		height: float,

		draw_border: bool,

		piece_border_color: Color,

		piece_border_width: float

	) -> void:


		texture = source_texture


		original_x = x

		original_y = y


		piece_size = Vector2(
			width,
			height
		)


		size = piece_size

		custom_minimum_size = piece_size


		mouse_default_cursor_shape = (
			Control.CURSOR_POINTING_HAND
		)


		# ====================================================
		# TEXTURE RECT
		# ====================================================

		texture_rect = TextureRect.new()


		texture_rect.position = Vector2.ZERO

		texture_rect.size = piece_size


		# MUITO IMPORTANTE:
		# A textura não recebe mouse.
		# Quem recebe é a peça.
		texture_rect.mouse_filter = (
			Control.MOUSE_FILTER_IGNORE
		)


		# Não queremos que o Godot faça
		# um redimensionamento desnecessário.
		texture_rect.expand_mode = (
			TextureRect.EXPAND_IGNORE_SIZE
		)


		# Mantém cada parte da imagem preenchendo
		# exatamente sua peça.
		texture_rect.stretch_mode = (
			TextureRect.STRETCH_SCALE
		)


		add_child(texture_rect)


		# ====================================================
		# ATLAS TEXTURE
		# ====================================================

		var atlas := AtlasTexture.new()


		atlas.atlas = source_texture


		var image_size := (
			source_texture.get_size()
		)


		var source_piece_width := (

			image_size.x
			/ float(total_columns)
		)


		var source_piece_height := (

			image_size.y
			/ float(total_rows)
		)


		atlas.region = Rect2(

			x * source_piece_width,

			y * source_piece_height,

			source_piece_width,

			source_piece_height
		)


		# A textura original é usada diretamente.
		texture_rect.texture = atlas


		# ====================================================
		# BORDA
		# ====================================================

		if draw_border:

			var style := StyleBoxFlat.new()


			style.bg_color = Color(
				0,
				0,
				0,
				0
			)


			style.border_color = (
				piece_border_color
			)


			style.border_width_left = (
				int(piece_border_width)
			)


			style.border_width_right = (
				int(piece_border_width)
			)


			style.border_width_top = (
				int(piece_border_width)
			)


			style.border_width_bottom = (
				int(piece_border_width)
			)


			# Um pequeno painel transparente
			# apenas para desenhar a borda.
			var border_panel := Panel.new()


			border_panel.position = Vector2.ZERO

			border_panel.size = piece_size

			border_panel.mouse_filter = (
				Control.MOUSE_FILTER_IGNORE
			)


			border_panel.add_theme_stylebox_override(
				"panel",
				style
			)


			add_child(border_panel)


	# ========================================================
	# COMEÇA DRAG
	# ========================================================

	func _get_drag_data(
		at_position: Vector2
	):

		if puzzle.solved:

			return null


		dragging = true


		puzzle.piece_started_dragging(
			self
		)


		# ====================================================
		# PREVIEW
		# ====================================================

		var preview := Control.new()


		preview.size = piece_size

		preview.mouse_filter = (
			Control.MOUSE_FILTER_IGNORE
		)


		var preview_texture := TextureRect.new()


		preview_texture.size = piece_size


		preview_texture.mouse_filter = (
			Control.MOUSE_FILTER_IGNORE
		)


		preview_texture.texture = (
			texture_rect.texture
		)


		preview_texture.expand_mode = (
			TextureRect.EXPAND_IGNORE_SIZE
		)


		preview_texture.stretch_mode = (
			TextureRect.STRETCH_SCALE
		)


		preview.add_child(
			preview_texture
		)


		preview.modulate = Color(
			1.0,
			1.0,
			1.0,
			0.85
		)


		set_drag_preview(
			preview
		)


		return self


	# ========================================================
	# PODE RECEBER DROP?
	# ========================================================

	func _can_drop_data(
		at_position: Vector2,
		data
	) -> bool:

		if puzzle.solved:

			return false


		if data is PuzzlePiece:

			if data == self:

				return false


			return true


		return false


	# ========================================================
	# RECEBE DROP
	# ========================================================

	func _drop_data(
		at_position: Vector2,
		data
	) -> void:

		if not data is PuzzlePiece:

			return


		var dragged_piece: PuzzlePiece = (
			data
		)


		dragging = false


		puzzle.drop_piece(
			dragged_piece,
			self
		)


		puzzle.piece_finished_dragging(
			dragged_piece
		)


	# ========================================================
	# DRAG CANCELADO
	# ========================================================

	func _notification(
		what: int
	) -> void:

		if what == NOTIFICATION_DRAG_END:

			if dragging:

				dragging = false


				if puzzle != null:

					puzzle.piece_finished_dragging(
						self
					)
					
func create_board_border() -> void:

	# Remove a borda anterior ao reiniciar
	if $Board.has_node("BoardBorder"):
		$Board.get_node("BoardBorder").queue_free()

	# ====================================================
	# BORDA
	# ====================================================

	var border := Panel.new()

	border.name = "BoardBorder"
	border.position = Vector2.ZERO
	border.size = board_size

	border.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var style := StyleBoxFlat.new()

	style.bg_color = Color(0, 0, 0, 0)

	style.border_color = Color(
		0.05,
		0.05,
		0.05,
		1.0
	)

	style.border_width_left = 15
	style.border_width_right = 15
	style.border_width_top = 15
	style.border_width_bottom = 15

	border.add_theme_stylebox_override(
		"panel",
		style
	)

	$Board.add_child(border)

	border.z_index = 100


	# ====================================================
	# LABEL DE INSTRUÇÃO
	# ====================================================

	var instruction_label := Label.new()

	instruction_label.name = "InstructionLabel"

	instruction_label.text = "Monte o quebra cabeças arrastando com o mouse,
	concluindo você recuperará todas as árvores destruidas com incêndio"

	instruction_label.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_CENTER
	)

	instruction_label.vertical_alignment = (
		VERTICAL_ALIGNMENT_CENTER
	)

	# Posição acima do tabuleiro
	instruction_label.position = Vector2(
		0,
		-65
	)

	instruction_label.size = Vector2(
		board_size.x,
		35
	)

	instruction_label.mouse_filter = (
		Control.MOUSE_FILTER_IGNORE
	)

	instruction_label.add_theme_font_size_override(
		"font_size",
		20
	)

	instruction_label.add_theme_color_override(
		"font_color",
		Color.WHITE
	)

	instruction_label.add_theme_color_override(
		"font_shadow_color",
		Color.BLACK
	)

	instruction_label.add_theme_constant_override(
		"shadow_offset_x",
		2
	)

	instruction_label.add_theme_constant_override(
		"shadow_offset_y",
		2
	)

	$Board.add_child(instruction_label)

	instruction_label.z_index = 101
