extends Node2D

# Dimensions du plateau (modifiable)
const COLS = 7
const ROWS = 6

# Plateau interne : 0 = vide, 1 = pièce rouge, 2 = pièce jaune
var board = []
var current_player = 1

# Compteur de victoires pour chaque joueur
var win_count = {1: 0, 2: 0}

# Références aux nœuds (vérifiez que les chemins correspondent à votre scène)
@onready var spawnCoin = $SpawnCoin    # Node contenant les fonctions de spawn (redspawn/yellowspawn)
@onready var grid = $Grid              # Node de la grille (pour la position et dimensions)
@onready var cells = $Cells            # Node regroupant tous les Marker2D

# Dictionnaire qui associe "row_col" à la position globale de chaque cellule (Marker2D)
var cell_markers = {}

func _ready():
	# Initialisation du plateau de jeu (board) avec des zéros
	for r in range(ROWS):
		board.append([])
		for c in range(COLS):
			board[r].append(0)
	
	# Remplissage du dictionnaire cell_markers
	# On suppose que chaque Marker2D est nommé "cell_<row>_<col>"
	for marker in cells.get_children():
		var parts = marker.name.split("_")
		if parts.size() >= 3:
			var row = int(parts[1])
			var col = int(parts[2])
			cell_markers["%d_%d" % [row, col]] = marker.global_position

func _input(event):
	# Détecte un clic gauche et détermine la colonne correspondante
	if event.is_action_pressed("Use"):
		var col = get_column_from_click(event.position)
		if col != null:
			drop_coin_in_column(col)

# Calcule la colonne à partir de la position du clic.
# On ajoute cell_width/2 pour ajuster le décalage si les markers sont centrés.
func get_column_from_click(click_pos: Vector2) -> Variant:
	var cell_width = 64.0  # Ajustez selon la largeur réelle de vos cellules en pixel art
	var col = int((click_pos.x - grid.global_position.x + cell_width / 2) / cell_width)
	if col < 0 or col >= COLS:
		return null
	return col

# Dépose une pièce dans la colonne indiquée
func drop_coin_in_column(col: int):
	# Recherche la première case vide dans la colonne (en partant du bas)
	var row = -1
	for r in range(ROWS - 1, -1, -1):
		if board[r][col] == 0:
			row = r
			break
	
	if row == -1:
		print("Colonne pleine")
		return
	
	# Met à jour le plateau de jeu
	board[row][col] = current_player
	
	# Récupère la position du Marker2D correspondant à la cellule (row, col)
	var marker_key = "%d_%d" % [row, col]
	if marker_key in cell_markers:
		var spawn_pos = cell_markers[marker_key]
		# Selon le joueur, on spawn la pièce rouge ou jaune
		if current_player == 1:
			spawnCoin.redspawn(spawn_pos)
		else:
			spawnCoin.yellowspawn(spawn_pos)
	else:
		print("Aucun marker pour la cellule ", row, col)
	
	# Vérifie la victoire
	if check_win(row, col):
		win_count[current_player] += 1
		print("Le joueur ", current_player, " gagne !")
		print("Score: Joueur 1:", win_count[1], " Joueur 2:", win_count[2])
		# Vous pouvez ici réinitialiser la partie ou désactiver les entrées
	else:
		# Change le joueur
		current_player = 2 if current_player == 1 else 1

# Vérifie si le joueur a aligné 4 pièces (horizontal, vertical et diagonales)
func check_win(row: int, col: int) -> bool:
	var player = board[row][col]
	var directions = [
		Vector2(1, 0),   # horizontal
		Vector2(0, 1),   # vertical
		Vector2(1, 1),   # diagonale bas-droite
		Vector2(1, -1)   # diagonale haut-droite
	]
	
	for dir in directions:
		var count = 1
		# Comptage dans la direction positive
		count += count_in_direction(row, col, int(dir.y), int(dir.x), player)
		# Comptage dans la direction opposée
		count += count_in_direction(row, col, -int(dir.y), -int(dir.x), player)
		if count >= 4:
			return true
	return false

# Compte le nombre de pièces consécutives dans une direction donnée
func count_in_direction(row: int, col: int, dy: int, dx: int, player: int) -> int:
	var count = 0
	var r = row + dy
	var c = col + dx
	while r >= 0 and r < ROWS and c >= 0 and c < COLS and board[r][c] == player:
		count += 1
		r += dy
		c += dx
	return count

# Fonction d'accès pour obtenir le nombre de victoires d'un joueur
func get_win_count(player: int) -> int:
	return win_count[player]
