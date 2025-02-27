extends Node2D

@onready var player1_timer: Timer = $PlayerTimer1
@onready var player2_timer: Timer = $PlayerTimer2
@onready var player1_label: Label = $Player1Label
@onready var player2_label: Label = $Player2Label

var player1_time_left: float = 300.0  
var player2_time_left: float = 300.0  
var current_player: int = 1  

func _ready():
	
	player1_timer.wait_time = 1.0
	player1_timer.timeout.connect(_on_timer_timeout.bind(1))
	
	player2_timer.wait_time = 1.0
	player2_timer.timeout.connect(_on_timer_timeout.bind(2))

	
	player1_timer.start()
	_update_display()

func _on_timer_timeout(player: int):
	if player == 1:
		player1_time_left -= 1
		if player1_time_left <= 0:
			_game_over(1)
	else:
		player2_time_left -= 1
		if player2_time_left <= 0:
			_game_over(2)

	_update_display()

func _update_display():
	player1_label.text = _format_time(player1_time_left)
	player2_label.text = _format_time(player2_time_left)

func _format_time(time_left: float) -> String:
	var minutes = int(time_left) / 60
	var seconds = int(time_left) % 60
	return "%02d:%02d" % [minutes, seconds]

func switch_turn():
	if current_player == 1:
		player1_timer.stop()
		player2_timer.start()
		current_player = 2
	else:
		player2_timer.stop()
		player1_timer.start()
		current_player = 1

func _game_over(player: int):
	print("Le joueur %d a perdu par le temps !" % player)
	player1_timer.stop()
	player2_timer.stop()
