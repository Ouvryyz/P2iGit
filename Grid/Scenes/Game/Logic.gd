extends Node

const ROWS = 6
const COLUMNS = 7

func check_victory(row, col, player):
	return check_direction(row, col, player, 1, 0) or  check_direction(row, col, player, 0, 1) or  check_direction(row, col, player, 1, 1) or  check_direction(row, col, player, 1, -1)    

func check_direction(row, col, player, dir_x, dir_y):
	var count = 1
	for i in [-1, 1]:  # Vérifie dans les deux directions
		var r = row + dir_y * i
		var c = col + dir_x * i
		while r >= 0 and r < ROWS and c >= 0 and c < COLUMNS and get_parent().board[r][c] == player:
			count += 1
			if count == 4:
				return true
			r += dir_y * i
			c += dir_x * i
	return false
