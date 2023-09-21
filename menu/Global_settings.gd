extends Node

func toggle_display_mode(value):
	match value:
		"FULLSCREEN":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		"BORDERLESS":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		"WINDOWED":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		_:
			print("ERROR in toggle_display_mode: incorrect value")

func toggle_vsync(value):
	if value:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		
func toggle_fps_counter(value):
	var fps_counter = get_tree().root.get_node("World/CanvasLayer/FpsCounter")
	if value:
		fps_counter.show()
	else:
		fps_counter.hide()
