extends Node2D


signal Win(player)
signal PlayerChange(player)
signal Stalemate

@onready var Columns_node = get_node("Colonnes")
@onready var grid = get_node("Grille2")

@onready var P1P = preload("res://Grid/Scenes/Board/Player1.tscn")
@onready var P2P = preload("res://Grid/Scenes/Board/Player2.tscn")

var player_turn = 1
var rows = 6
var cols = 7
var grid_data = []  


func _ready():
	_init_grid()

func _init_grid():
	grid_data = []
	for i in range(cols):
		grid_data.append([0] * rows)  


func place_puck(column):
	if column < 0 or column >= cols:
		return false
	
	
	for row in range(rows):
		if grid_data[column][row] == 0:
			grid_data[column][row] = player_turn
			_spawn_piece(column, row, player_turn)
			
			
			if check_win(player_turn):
				emit_signal("Win", player_turn)
			elif check_stalemate():
				emit_signal("Stalemate")
			else:
				_switch_player()
			return true
	return false 

func _spawn_piece(col, row, player):
	var piece = P1P.instantiate() if player == 1 else P2P.instantiate()
	var column_node = Columns_node.get_child(col)
	column_node.add_child(piece)
	piece.global_position = column_node.get_child(row).global_position  # Alignement parfait


func _switch_player():
	player_turn = 3 - player_turn  
	emit_signal("PlayerChange", player_turn)


func check_win(player):
	# Vérification horizontale
	for row in range(rows):
		for col in range(cols - 3):
			if grid_data[col][row] == player and grid_data[col + 1][row] == player and grid_data[col + 2][row] == player and grid_data[col + 3][row] == player:
				return true
	
	# Vérification verticale
	for col in range(cols):
		for row in range(rows - 3):
			if grid_data[col][row] == player and grid_data[col][row + 1] == player and grid_data[col][row + 2] == player and grid_data[col][row + 3] == player:
				return true

	# Vérification diagonale 
	for col in range(cols - 3):
		for row in range(rows - 3):
			if grid_data[col][row] == player and grid_data[col + 1][row + 1] == player and grid_data[col + 2][row + 2] == player and grid_data[col + 3][row + 3] == player:
				return true

	# Vérification diagonale 
	for col in range(3, cols):
		for row in range(rows - 3):
			if grid_data[col][row] == player and grid_data[col - 1][row + 1] == player and grid_data[col - 2][row + 2] == player and grid_data[col - 3][row + 3] == player:
				return true

	return false


func check_stalemate():
	for col in grid_data:
		if 0 in col:
			return false
	return true


func _on_Column_1_pressed():
	place_puck(0)
func _on_Column_2_pressed():
	place_puck(1)
func _on_Column_3_pressed():
	place_puck(2)
func _on_Column_4_pressed():
	place_puck(3)
func _on_Column_5_pressed():
	place_puck(4)
func _on_Column_6_pressed():
	place_puck(5)
func _on_Column_7_pressed():
	place_puck(6)
