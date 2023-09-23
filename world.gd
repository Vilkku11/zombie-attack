extends Node

@onready var main_menu = $CanvasLayer/MainMenu
@onready var ingame_menu = $CanvasLayer/InGameMenu

@onready var address_entry = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/AddressEntry
@onready var hud = $CanvasLayer/HUD
@onready var health_bar = $CanvasLayer/HUD/HealthBar
@onready var settings = $CanvasLayer/Settings

@onready var inventory_interface = $CanvasLayer/HUD/InventoryInterface



var level

const Player = preload("res://player/player.tscn")
const PORT = 9999
var enet_peer = ENetMultiplayerPeer.new()


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _unhandled_input(event):
	if Input.is_action_just_pressed("quit"):
			if main_menu.is_visible():
				print("test")
				get_tree().quit()
			elif ingame_menu.is_visible():
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
				ingame_menu.hide()
				main_menu.show()
			else:
				main_menu.hide()
				ingame_menu.show()
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
				
		


func _on_settings_pressed():
	hud.hide()
	main_menu.hide()
	settings.show()
	
	
func _on_quit_pressed():
	get_tree().quit()
	

func _on_test_level_btn_pressed():
	get_node("Environment").free()
	var environment = preload("res://environment.tscn").instantiate()
	get_tree().root.add_child(environment)
	var player = preload("res://player/player.tscn").instantiate()
	get_tree().root.add_child(player)
	player.position = Vector3(1, 1,1)
	main_menu.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	

func toggle_inventory_interface(external_inventory_owner = null) -> void:
	inventory_interface.visible = not inventory_interface.visible
	
	if inventory_interface.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if external_inventory_owner and inventory_interface.visible:
		inventory_interface.set_external_inventory(external_inventory_owner)
	else:
		inventory_interface.clear_external_inventory()
	
	
func update_health_bar(health_value):
	health_bar.value = health_value
	







