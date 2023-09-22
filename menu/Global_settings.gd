extends Node




# Default settings
var display_mode = 2
var vsync = true
var fps_counter = true
var resolution = "1920,1080"
var aspect_ratio = "16:9"

func save_config():
	var config = ConfigFile.new()
	config.set_value("SETTING", "display_mode", display_mode)
	config.set_value("SETTING", "vsync", vsync)
	config.set_value("SETTING", "fps_counter", fps_counter)
	config.set_value("SETTING", "resolution", resolution)
	config.set_value("SETTING", "aspect_ratio", aspect_ratio)
	config.save("res://config.cfg")
	print("in save_config")
	

func load_config():
	var config = ConfigFile.new()
	
	var err = config.load("res://config.cfg")
	
	if err != OK:
		return
		
	for setting in config.get_sections():
		display_mode = config.get_value("SETTING", "display_mode")
		vsync = config.get_value("SETTING", "vsync")
		fps_counter = config.get_value("SETTING", "fps_counter")
		resolution = config.get_value("SETTING", "resolution")
		aspect_ratio = config.get_value("SETTING", "aspect_ratio")
		
	toggle_display_mode(display_mode)
	toggle_vsync(vsync)
	toggle_fps_counter(fps_counter)

func _ready():
	load_config()

	


func toggle_display_mode(value):
	
	match value:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			GlobalSettings.display_mode = 0
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			GlobalSettings.display_mode = 1
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			GlobalSettings.display_mode = 2
		_:
			print("ERROR in toggle_display_mode: incorrect value")

func toggle_vsync(value):
	GlobalSettings.vsync = value
	if value:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		
func toggle_fps_counter(value):
	GlobalSettings.fps_counter = value
	var fps_counter = get_tree().root.get_node("World/CanvasLayer/FpsCounter")
	if value:
		fps_counter.show()
	else:
		fps_counter.hide()

func toggle_resolution(value):
	pass

func toggle_aspect_ratio(value):
	pass
