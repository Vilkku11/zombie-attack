extends PanelContainer
# HUD
@onready var main_menu = $"../MainMenu"
@onready var settings = $"."

# Video setting BTN's
@onready var display_mode_btn = $MarginContainer/TabContainer/Video/MarginContainer/GridContainer/DisplayModeBtn
@onready var vsync_btn = $MarginContainer/TabContainer/Video/MarginContainer/GridContainer/VsyncBtn
@onready var showfps_btn = $MarginContainer/TabContainer/Video/MarginContainer/GridContainer/ShowFpsBtn


func add_items():
	
	display_mode_btn.add_item("Fullscreen")
	display_mode_btn.add_item("Windowed fullscreen")
	display_mode_btn.add_item("Windowed")
	display_mode_btn.select(2)





func _on_back_pressed():
	settings.hide()
	main_menu.show()

# Called when the node enters the scene tree for the first time.
func _ready():
	add_items()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass





func _on_display_mode_btn_item_selected(index):
	match index:
		0:
			GlobalSettings.toggle_display_mode("FULLSCREEN")
		1:
			GlobalSettings.toggle_display_mode("BORDERLESS")
		2:
			GlobalSettings.toggle_display_mode("WINDOWED")
		_:
			print("error")
	




func _on_vsync_btn_toggled(button_pressed):
	GlobalSettings.toggle_vsync(button_pressed)


func _on_show_fps_btn_toggled(button_pressed):
	GlobalSettings.toggle_fps_counter(button_pressed)
