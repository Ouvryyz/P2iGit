extends Node2D

@export var red_token_scene: PackedScene
@export var yellow_token_scene: PackedScene

const ROWS = 6
const COLUMNS = 7
var board = []
var current_player = 1

func _ready():
	reset_board()

func reset_board():
	board = []
	for row in range(ROWS):
		board.append([])
		for col in range(COLUMNS):
			board[row].append(0)

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var column = int(event.position.x / 100)
		place_token(column)

func place_token(column):
	for row in range(ROWS - 1, -1, -1):
		if board[row][column] == 0:
			board[row][column] = current_player
			spawn_token(column, row, current_player)
			if $Logic.check_victory(row, column, current_player):
				print("Joueur " + str(current_player) + " gagne !")
			current_player = 3 - current_player
			return

func spawn_token(column, row, player):
	var token = red_token_scene.instantiate() if player == 1 else yellow_token_scene.instantiate()
	token.position = Vector2(column * 100 + 50, -50)  # Commence en haut de l'écran
	token.drop(Vector2(column * 100 + 50, row * 100 + 50))  # Anime la descente
	$TokenContainer.add_child(token)
