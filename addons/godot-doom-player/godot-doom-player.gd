@tool
extends EditorPlugin

const MainPanel: = preload("res://addons/godot-doom-player/scenes/main/main.tscn")

const WAD_SETTING: = "DOOM/settings/wad/wad_path_%d"
const DEFAULT_WAD_PATH: = "res://addons/godot-doom-player/resources/wad/DOOM1.WAD"
const SOUNDFONT_SETTING: = "DOOM/settings/soundfont/soundfont_path"
const DEFAULT_SOUNDFONT_PATH: = "res://addons/godot-doom-player/resources/sf3/MuseScore_General.sf3"

var main_panel_instance


func _enter_tree() -> void:
	main_panel_instance = MainPanel.instantiate()
	get_editor_interface().get_editor_main_screen().add_child(main_panel_instance)
	_make_visible(false)

	init_project_settings()


func _exit_tree() -> void:
	if main_panel_instance != null:
		main_panel_instance.queue_free()


func _has_main_screen() -> bool:
	return true


func _make_visible(visible: bool) -> void:
	if main_panel_instance != null:
		main_panel_instance.visible = visible


func _get_plugin_name() -> String:
	return "DOOM"


func _get_plugin_icon() -> Texture2D:
	return get_editor_interface().get_base_control().get_theme_icon("Node", "EditorIcons")


func init_project_settings() -> void:
	init_wad_settings()
	init_soundfont_settings()

	ProjectSettings.save()


func init_wad_settings() -> void:
	for i in range(1, 11):
		var wad_setting: = WAD_SETTING % i
		if not ProjectSettings.has_setting(wad_setting):
			if i == 1:
				ProjectSettings.set_setting(wad_setting, DEFAULT_WAD_PATH)
				ProjectSettings.set_initial_value(wad_setting, DEFAULT_WAD_PATH)
			else:
				ProjectSettings.set_setting(wad_setting, "")
				ProjectSettings.set_initial_value(wad_setting, "")
		ProjectSettings.set_as_basic(wad_setting, true)
		var wad_property_info: = {
			"name": wad_setting,
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_FILE
		}
		ProjectSettings.add_property_info(wad_property_info)


func init_soundfont_settings() -> void:
	if not ProjectSettings.has_setting(SOUNDFONT_SETTING):
		ProjectSettings.set_setting(SOUNDFONT_SETTING, DEFAULT_SOUNDFONT_PATH)
	ProjectSettings.set_initial_value(SOUNDFONT_SETTING, DEFAULT_SOUNDFONT_PATH)
	ProjectSettings.set_as_basic(SOUNDFONT_SETTING, true)
	var soundfont_property_info: = {
		"name": SOUNDFONT_SETTING,
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_FILE
	}
	ProjectSettings.add_property_info(soundfont_property_info)
