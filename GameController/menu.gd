extends Node

@onready var resolution_dropdown: OptionButton = $ResolutionDropdown

# Liste des résolutions disponibles (tu peux en ajouter)
var resolutions := [
	{"label": "640 x 360", "size": Vector2i(640, 360)},
	{"label": "1280 x 720", "size": Vector2i(1280, 720)},
	{"label": "1920 x 1080", "size": Vector2i(1920, 1080)}
]

func _ready():
	# Remplit le menu déroulant
	for res in resolutions:
		resolution_dropdown.add_item(res.label)

	# Sélectionne l'option correspondant à la résolution actuelle (si existante)
	var current_size = DisplayServer.window_get_size()
	for i in resolutions.size():
		if resolutions[i].size == current_size:
			resolution_dropdown.select(i)
			break

	# Connecte le signal
	resolution_dropdown.item_selected.connect(_on_resolution_selected)

func _on_resolution_selected(index: int) -> void:
	var selected_size = resolutions[index].size
	DisplayServer.window_set_size(selected_size)

	# Centre la fenêtre sur l’écran
	var screen_size = DisplayServer.screen_get_size()
	var pos = (screen_size - selected_size) / 2
	DisplayServer.window_set_position(pos)

	print("Nouvelle résolution appliquée :", selected_size)
