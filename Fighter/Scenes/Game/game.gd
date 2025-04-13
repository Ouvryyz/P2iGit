extends Node2D

signal player_defeated(who: String)


@onready var player1_life_bar: TextureRect = $Player1LifeBar
@onready var sprite: TextureRect = $CooldownSpriteHeal1
@onready var label: Label = $CooldownSpriteHeal1/CooldownTimerLabelHeal1

@onready var player2_life_bar: TextureRect = $Player2LifeBar

@onready var heal_sprite_2: TextureRect = $CooldownSpriteHeal2
@onready var heal_label_2: Label = $CooldownSpriteHeal2/CooldownTimerLabelHeal2

@onready var dash_sprite_2: TextureRect = $CooldownSpriteDash2
@onready var dash_label_2: Label = $CooldownSpriteDash2/CooldownTimerLabelDash1

func _input(event: InputEvent):
	if event.is_action_pressed("ui_cancel"):
		var pause_menu = get_node_or_null("/root/PauseMenu")
		if pause_menu:
			pause_menu.show_pause()

func notify_player_death(player_name: String):
	emit_signal("player_defeated", player_name)

@onready var defeat_label: Label = $DefeatMessage

func show_defeat_message(player_name: String) -> void:
	defeat_label.text = "%s a été vaincu !" % player_name
	defeat_label.visible = true

var life_bar_textures := [
	preload("res://Fighter/Sprites/BarreViePlayerRed1.webp"),  
	preload("res://Fighter/Sprites/BarreViePlayerRed2.webp"), 
	preload("res://Fighter/Sprites/BarreViePlayerRed3.webp"),  
	preload("res://Fighter/Sprites/BarreViePlayerRed4.webp"),  
	preload("res://Fighter/Sprites/BarreViePlayerRed5.webp"),  
	preload("res://Fighter/Sprites/BarreViePlayerRed6.webp"),  
	preload("res://Fighter/Sprites/BarreViePlayerRed7.webp"),  
	preload("res://Fighter/Sprites/BarreViePlayerRed8.webp"),  
	preload("res://Fighter/Sprites/BarreViePlayerRed9.webp"),  
	preload("res://Fighter/Sprites/BarreViePlayerRed10.webp"), 
	preload("res://Fighter/Sprites/BarreViePlayerRed12.webp")  
]


var cooldown_textures := [
	preload("res://Fighter/Sprites/Cooldwonmultiple4Red1.webp"),
	preload("res://Fighter/Sprites/Cooldwonmultiple4Red2.webp"),
	preload("res://Fighter/Sprites/Cooldwonmultiple4Red3.webp"),
	preload("res://Fighter/Sprites/Cooldwonmultiple4Red4.webp"),
	preload("res://Fighter/Sprites/Cooldwonmultiple4Red5.webp"),
	preload("res://Fighter/Sprites/Cooldwonmultiple4Red6.webp"),
	preload("res://Fighter/Sprites/Cooldwonmultiple4Red7.webp"),
	preload("res://Fighter/Sprites/Cooldwonmultiple4Red8.webp"),
	preload("res://Fighter/Sprites/Cooldwonmultiple4Red9.webp")
]
@onready var dash_sprite: TextureRect = $CooldownSpriteDash1
@onready var dash_label: Label = $CooldownSpriteDash1/CooldownTimerLabelDash1

var dash_cooldown_textures := [
	preload("res://Fighter/Sprites/Cooldwonmultiple4Red1.webp"),
	preload("res://Fighter/Sprites/Cooldwonmultiple4Red2.webp"),
	preload("res://Fighter/Sprites/Cooldwonmultiple4Red3.webp"),
	preload("res://Fighter/Sprites/Cooldwonmultiple4Red4.webp"),
	preload("res://Fighter/Sprites/Cooldwonmultiple4Red5.webp"),
	preload("res://Fighter/Sprites/Cooldwonmultiple4Red6.webp"),
	preload("res://Fighter/Sprites/Cooldwonmultiple4Red7.webp"),
	preload("res://Fighter/Sprites/Cooldwonmultiple4Red8.webp"),
	preload("res://Fighter/Sprites/Cooldwonmultiple4Red9.webp")
]

func start_dash_cooldown(duration := 8.0):
	dash_label.visible = true
	dash_sprite.visible = true

	var elapsed := 0.0
	while elapsed < duration:
		var progress_ratio = clamp(elapsed / duration, 0.0, 1.0)
		var index = int(progress_ratio * (dash_cooldown_textures.size() - 1))
		dash_sprite.texture = dash_cooldown_textures[index]

		var seconds_left = ceil(duration - elapsed)
		dash_label.text = str(int(seconds_left))

		await get_tree().create_timer(0.1).timeout
		elapsed += 0.1

	
	dash_sprite.texture = dash_cooldown_textures[0]
	dash_label.visible = false


var cooldown_duration := 4.0
var is_cooling := false

func _ready() -> void:
	sprite.texture = cooldown_textures[0]
	sprite.visible = true
	label.visible = false
	dash_sprite.texture = dash_cooldown_textures[0]
	dash_sprite.visible = true
	dash_label.visible = false


func update_player1_life_bar(health: int) -> void:
	var index = clamp(10 - (health / 10), 0, life_bar_textures.size() - 1)
	player1_life_bar.texture = life_bar_textures[index]

func start_cooldown():
	is_cooling = true
	label.visible = true
	sprite.visible = true

	var elapsed := 0.0
	while elapsed < cooldown_duration:
		var progress_ratio = clamp(elapsed / cooldown_duration, 0.0, 1.0)
		var index = int(progress_ratio * (cooldown_textures.size() - 1))
		
		# On affiche une image de progression (2 à 9) mais jamais la première
		sprite.texture = cooldown_textures[index]

		var seconds_left = ceil(cooldown_duration - elapsed)
		label.text = str(int(seconds_left))

		await get_tree().create_timer(0.1).timeout
		elapsed += 0.1

	# Revenir à l'image pleine à la fin
	sprite.texture = cooldown_textures[0]
	label.visible = false
	is_cooling = false



var life_bar_textures_2 := [
	preload("res://Fighter/Sprites/BarreViePlayerYellow1 Copy1.webp"),
	preload("res://Fighter/Sprites/BarreViePlayerYellow1 Copy2.webp"),
	preload("res://Fighter/Sprites/BarreViePlayerYellow1 Copy3.webp"),
	preload("res://Fighter/Sprites/BarreViePlayerYellow1 Copy4.webp"),
	preload("res://Fighter/Sprites/BarreViePlayerYellow1 Copy5.webp"),
	preload("res://Fighter/Sprites/BarreViePlayerYellow1 Copy6.webp"),
	preload("res://Fighter/Sprites/BarreViePlayerYellow1 Copy7.webp"),
	preload("res://Fighter/Sprites/BarreViePlayerYellow1 Copy8.webp"),
	preload("res://Fighter/Sprites/BarreViePlayerYellow1 Copy9.webp"),
	preload("res://Fighter/Sprites/BarreViePlayerYellow1 Copy10.webp"),
	preload("res://Fighter/Sprites/BarreViePlayerYellow1 Copy12.webp"),
]

var cooldown_textures_yellow := [
	preload("res://Fighter/Sprites/Cooldwonmultiple4Yellow1.webp"),
	preload("res://Fighter/Sprites/Cooldwonmultiple4Yellow2.webp"),
	preload("res://Fighter/Sprites/Cooldwonmultiple4Yellow3.webp"),
	preload("res://Fighter/Sprites/Cooldwonmultiple4Yellow4.webp"),
	preload("res://Fighter/Sprites/Cooldwonmultiple4Yellow5.webp"),
	preload("res://Fighter/Sprites/Cooldwonmultiple4Yellow6.webp"),
	preload("res://Fighter/Sprites/Cooldwonmultiple4Yellow7.webp"),
	preload("res://Fighter/Sprites/Cooldwonmultiple4Yellow8.webp"),
	preload("res://Fighter/Sprites/Cooldwonmultiple4Yellow9.webp")
]
func update_player2_life_bar(health: int) -> void:
	var index = clamp(10 - (health / 10), 0, life_bar_textures_2.size() - 1)
	player2_life_bar.texture = life_bar_textures_2[index]

func start_heal_cooldown_player2(duration := 15.0):
	heal_label_2.visible = true
	heal_sprite_2.visible = true

	var elapsed := 0.0
	while elapsed < duration:
		var ratio = clamp(elapsed / duration, 0.0, 1.0)
		var index = int(ratio * (cooldown_textures_yellow.size() - 1))
		heal_sprite_2.texture = cooldown_textures_yellow[index]
		heal_label_2.text = str(int(ceil(duration - elapsed)))
		await get_tree().create_timer(0.1).timeout
		elapsed += 0.1

	heal_sprite_2.texture = cooldown_textures_yellow[0]
	heal_label_2.visible = false

func start_dash_cooldown_player2(duration := 8.0):
	dash_label_2.visible = true
	dash_sprite_2.visible = true

	var elapsed := 0.0
	while elapsed < duration:
		var ratio = clamp(elapsed / duration, 0.0, 1.0)
		var index = int(ratio * (cooldown_textures_yellow.size() - 1))
		dash_sprite_2.texture = cooldown_textures_yellow[index]
		dash_label_2.text = str(int(ceil(duration - elapsed)))
		await get_tree().create_timer(0.1).timeout
		elapsed += 0.1

	dash_sprite_2.texture = cooldown_textures_yellow[0]
	dash_label_2.visible = false
