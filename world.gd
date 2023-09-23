extends Node

@onready var main_menu = $CanvasLayer/MainMenu
@onready var ingame_menu = $CanvasLayer/InGameMenu

@onready var address_entry = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/AddressEntry
@onready var hud = $CanvasLayer/HUD
@onready var health_bar = $CanvasLayer/HUD/HealthBar
@onready var settings = $CanvasLayer/Settings

@onready var inventory_interface = $CanvasLayer/HUD/InventoryInterface


const Player = preload("res://player.tscn")
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
				
		



func _on_host_button_pressed():
	hud.show()
	main_menu.hide()
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	
	
	add_player(multiplayer.get_unique_id())
	#upnp_setup()



func _on_join_button_pressed():
	hud.show()
	main_menu.hide()
	enet_peer.create_client("localhost", PORT)
	multiplayer.multiplayer_peer = enet_peer
	


func _on_settings_pressed():
	hud.hide()
	main_menu.hide()
	settings.show()
	
	
func _on_quit_pressed():
	get_tree().quit()
	
	



func add_player(peer_id):
	var player = Player.instantiate()
	
	player.toggle_inventory.connect(toggle_inventory_interface)
	inventory_interface.set_player_inventory_data(player.inventory_data)
	
	for node in get_tree().get_nodes_in_group("external_inventory"):
		node.toggle_inventory.connect(toggle_inventory_interface)
	
	player.name = str(peer_id)
	add_child(player)
	if player.is_multiplayer_authority():
		player.health_changed.connect(update_health_bar)
		
		
		
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
	
func remove_player(peer_id):
	var player = get_node_or_null(str(peer_id))
	if player:
		player.queue_free()
	
func update_health_bar(health_value):
	health_bar.value = health_value
	


func _on_multiplayer_spawner_spawned(node):
	if node.is_multiplayer_authority():
		node.health_changed.connect(update_health_bar)

func upnp_setup():
	var upnp = UPNP.new()
	var discover_result = upnp.discover()
	assert(discover_result == UPNP.UPNP_RESULT_SUCCESS, "UPNP Discover Failed! Error %s" % discover_result)
	
	assert(upnp.get_gateway() and upnp.get_gateway().is_valid_gateway(), "UPNP Invalid Gateway!")

	var map_result = upnp.add_port_mapping(PORT)
	assert(map_result == UPNP.UPNP_RESULT_SUCCESS, "UPNP Port Mapping Failed! Error %s" % map_result)
	
	print("Success! Join Address: %s" % upnp.query_external_address())








