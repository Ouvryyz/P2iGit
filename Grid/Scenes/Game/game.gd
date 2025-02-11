extends Node2D


const COLS = 7
const ROWS = 6


var board = []
var current_player = 1


var win_count = {1: 0, 2: 0}


@onready var spawnCoin = $SpawnCoin    
@onready var grid = $Grid              
@onready var cells = $Cells            


var cell_markers = {}

func _ready():
	
	for r in range(ROWS):
		board.append([])
		for c in range(COLS):
			board[r].append(0)
	
	
	for marker in cells.get_children():
		var parts = marker.name.split("_")
		if parts.size() >= 3:
			var row = int(parts[1])
			var col = int(parts[2])
			cell_markers["%d_%d" % [row, col]] = marker.global_position

func _input(event):
	
	if event.is_action_pressed("Use"):
		var col = get_column_from_click(event.position)
		if col != null:
			drop_coin_in_column(col)


func get_column_from_click(click_pos: Vector2) -> Variant:
	var cell_width = 64.0  # Ajustez selon la largeur réelle de vos cellules en pixel art
	var col = int((click_pos.x - grid.global_position.x + cell_width / 2) / cell_width)
	if col < 0 or col >= COLS:
		return null
	return col


func drop_coin_in_column(col: int):
	var row = -1
	for r in range(ROWS - 1, -1, -1):
		if board[r][col] == 0:
			row = r
			break
	
	if row == -1:
		print("Colonne pleine")
		return
	board[row][col] = current_player
	var marker_key = "%d_%d" % [row, col]
	if marker_key in cell_markers:
		var spawn_pos = cell_markers[marker_key]
		if current_player == 1:
			spawnCoin.redspawn(spawn_pos)
		else:
			spawnCoin.yellowspawn(spawn_pos)
	else:
		print("Aucun marker pour la cellule ", row, col)
	
	
	if check_win(row, col):
		win_count[current_player] += 1
		print("Le joueur ", current_player, " gagne !")
		print("Score: Joueur 1:", win_count[1], " Joueur 2:", win_count[2])
	else:
		current_player = 2 if current_player == 1 else 1

func check_win(row: int, col: int) -> bool:
	var player = board[row][col]
	var directions = [
		Vector2(1, 0),   
		Vector2(0, 1),   
		Vector2(1, 1),   
		Vector2(1, -1)   
	]
	
	for dir in directions:
		var count = 1
		count += count_in_direction(row, col, int(dir.y), int(dir.x), player)
		count += count_in_direction(row, col, -int(dir.y), -int(dir.x), player)
		if count >= 4:
			return true
	return false


func count_in_direction(row: int, col: int, dy: int, dx: int, player: int) -> int:
	var count = 0
	var r = row + dy
	var c = col + dx
	while r >= 0 and r < ROWS and c >= 0 and c < COLS and board[r][c] == player:
		count += 1
		r += dy
		c += dx
	return count


func get_win_count(player: int) -> int:
	return win_count[player]
