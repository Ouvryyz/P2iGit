extends Node2D

@onready var spawn_coin = $SpawnCoin
@onready var cells = $Cells
@onready var player1_timer: Timer = $UI/PlayerTimer1
@onready var player2_timer: Timer = $UI/PlayerTimer2
@onready var player1_label: Label = $UI/Player1Label
@onready var player2_label: Label = $UI/Player2Label

const ROWS = 6
const COLS = 7

var grid = [] # Représente la grille du jeu
var current_player = "yellow"
var player1_time_left: float = 30.0  # 5 minutes
var player2_time_left: float = 30.0  # 5 minutes

func _ready():
	initialize_grid()
	connect_buttons()
	
	# Configuration des Timers
	player1_timer.wait_time = 1.0
	player1_timer.timeout.connect(_on_timer_timeout.bind("yellow"))
	
	player2_timer.wait_time = 1.0
	player2_timer.timeout.connect(_on_timer_timeout.bind("red"))

	# Lancer le timer du joueur jaune (1) au départ
	player1_timer.start()
	_update_display()

func initialize_grid():
	grid = []
	for i in range(ROWS):
		grid.append([])
		for j in range(COLS):
			grid[i].append(null)  # Initialise la grille vide

func connect_buttons():
	for i in range(1, COLS + 1):
		var button = get_node("cols/col_" + str(i))
		if button:
			button.pressed.connect(func(): _on_col_pressed(i - 1))

func drop_piece(column):
	var spawn_marker = get_node("Markers/Marker_" + str(column))
	if spawn_marker:
		var row = get_available_row(column)
		if row != -1:
			var cell_marker = get_node("Cells/cell_%d_%d" % [row, column])
			if cell_marker:
				var spawn_pos = spawn_marker.global_position
				if current_player == "yellow":
					spawn_coin.yellowspawn(spawn_pos)
					grid[row][column] = "yellow"
				else:
					spawn_coin.redspawn(spawn_pos)
					grid[row][column] = "red"
				
				if check_win(row, column):
					print(current_player + " wins!")
				
				on_piece_spawn()

func get_available_row(column):
	for i in range(ROWS - 1, -1, -1):
		if grid[i][column] == null:
			return i
	return -1

func switch_player():
	if current_player == "yellow":
		player1_timer.stop()
		player2_timer.start()
		current_player = "red"
	else:
		player2_timer.stop()
		player1_timer.start()
		current_player = "yellow"

func check_win(row, column):
	var player = grid[row][column]
	if not player:
		return false
	
	return (check_direction(row, column, 1, 0, player) or  # Horizontal
			check_direction(row, column, 0, 1, player) or  # Vertical
			check_direction(row, column, 1, 1, player) or  # Diagonal /
			check_direction(row, column, 1, -1, player))   # Diagonal \

func check_direction(row, column, d_row, d_col, player):
	var count = 1
	for dir in [-1, 1]:
		var r = row + d_row * dir
		var c = column + d_col * dir
		while r >= 0 and r < ROWS and c >= 0 and c < COLS and grid[r][c] == player:
			count += 1
			if count >= 4:
				return true
			r += d_row * dir
			c += d_col * dir
	return false

func _on_col_pressed(column):
	drop_piece(column)

func _on_timer_timeout(player: String):
	if player == "yellow":
		player1_time_left -= 1
		if player1_time_left <= 0:
			_game_over("yellow")
	else:
		player2_time_left -= 1
		if player2_time_left <= 0:
			_game_over("red")

	_update_display()

func _update_display():
	player1_label.text = _format_time(player1_time_left)
	player2_label.text = _format_time(player2_time_left)

func _format_time(time_left: float) -> String:
	var minutes = int(time_left) / 60
	var seconds = int(time_left) % 60
	return "%02d:%02d" % [minutes, seconds]

func _game_over(player: String):
	print("Le joueur %s a perdu par le temps !" % player)
	player1_timer.stop()
	player2_timer.stop()

func on_piece_spawn():
	switch_player()
