extends PanelContainer
# HUD
@onready var main_menu = $"../MainMenu"
@onready var settings = $"."
@onready var in_game_menu = $"../InGameMenu"

# Video setting BTN's
@onready var display_mode_btn = $MarginContainer/TabContainer/Video/MarginContainer/GridContainer/DisplayModeBtn
@onready var resolution_btn = $MarginContainer/TabContainer/Video/MarginContainer/GridContainer/ResolutionBtn
@onready var aspect_ratio_btn = $MarginContainer/TabContainer/Video/MarginContainer/GridContainer/AspectRatioBtn
@onready var vsync_btn = $MarginContainer/TabContainer/Video/MarginContainer/GridContainer/VsyncBtn
@onready var showfps_btn = $MarginContainer/TabContainer/Video/MarginContainer/GridContainer/ShowFpsBtn

# Mouse + Keyboard
@onready var mouse_sens_label = $"MarginContainer/TabContainer/Mouse + Keyboard2/MarginContainer/GridContainer/HBoxContainer/MouseSensLabel"
@onready var mouse_sens_slider = $"MarginContainer/TabContainer/Mouse + Keyboard2/MarginContainer/GridContainer/HBoxContainer/HSlider"
@onready var mouse_sens_text = $"MarginContainer/TabContainer/Mouse + Keyboard2/MarginContainer/GridContainer/HBoxContainer/TextEdit"
@onready var mouse_sens_spinbox = $"MarginContainer/TabContainer/Mouse + Keyboard2/MarginContainer/GridContainer/HBoxContainer/SpinBox"


func init_settings():
	
	display_mode_btn.add_item("Fullscreen")
	display_mode_btn.add_item("Windowed fullscreen")
	display_mode_btn.add_item("Windowed")
	display_mode_btn.select(GlobalSettings.display_mode)
	
	resolution_btn.add_item("1280 720")
	resolution_btn.add_item("1920 1080")

	vsync_btn.set_pressed_no_signal(GlobalSettings.vsync)
	showfps_btn.set_pressed_no_signal(GlobalSettings.fps_counter)
	print(GlobalSettings.mouse_sens)
	mouse_sens_label.text = str(GlobalSettings.mouse_sens)
	mouse_sens_slider.set_value_no_signal(GlobalSettings.mouse_sens)
	mouse_sens_spinbox.value = GlobalSettings.mouse_sens



func _on_back_pressed():
	settings.hide()
	main_menu.show()
	GlobalSettings.save_config()

# Called when the node enters the scene tree for the first time.
func _ready():
	init_settings()

func _on_display_mode_btn_item_selected(index):
	GlobalSettings.toggle_display_mode(index)
	
	
func _on_vsync_btn_toggled(button_pressed):
	GlobalSettings.toggle_vsync(button_pressed)

func _on_show_fps_btn_toggled(button_pressed):
	GlobalSettings.toggle_fps_counter(button_pressed)
	

func _on_resolution_btn_item_selected(index):
	GlobalSettings.toggle_resolution(index)
	
func _on_aspect_ratio_btn_item_selected(index):
	pass # Replace with function body.

 # 0.001
func _on_h_slider_value_changed(value):
	mouse_sens_label.text = str(value)
	mouse_sens_text.text = str(value)
	mouse_sens_spinbox.value = (value)
	#GlobalSettings.toggle_mouse_sens(value /10000)


func _on_spin_box_value_changed(value):
	mouse_sens_label.text = str(value)
	GlobalSettings.toggle_mouse_sens(value)
	if mouse_sens_slider.value != value:
		mouse_sens_slider.value = value
	


func _on_to_main_menu_btn_pressed():
	in_game_menu.hide()
	main_menu.show()


func _on_settings_btn_pressed():
	in_game_menu.hide()
	settings.show()
