extends CanvasLayer

@onready var btn_resume = $BtnReprendre
@onready var btn_quit = $BtnQuitter

func _ready():
	btn_resume.pressed.connect(_on_resume_pressed)
	btn_quit.pressed.connect(_on_quit_pressed)
	hide()

func show_pause():
	get_tree().paused = true
	show()

func _on_resume_pressed():
	get_tree().paused = false
	hide()

func _on_quit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://GameController/Menu.tscn")
