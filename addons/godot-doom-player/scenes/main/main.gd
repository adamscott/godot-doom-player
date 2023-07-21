@tool
extends MarginContainer


var editor_interface: EditorInterface  # Set in godot-doom-player.gd

@onready var doom: DOOM = %DOOM
@onready var size_option_button: OptionButton = %SizeOptionButton

const DOOM_MIN_WIDTH: = 320
const DOOM_MIN_HEIGHT: = 240

var assets_imported: = false

func _ready() -> void:
	doom.assets_imported.connect(_on_doom_assets_imported)
	update_paths()


func _on_doom_assets_imported() -> void:
	if editor_interface == null:
		return

	assets_imported = true
	if visible:
		print("doom enabled")
		doom.doom_enabled = true


func _on_visibility_changed() -> void:
	if editor_interface == null:
		return

	if visible:
		init_doom()
	else:
		kill_doom()


func update_paths() -> void:
	if editor_interface == null:
		return

	if doom == null:
		return

	doom.assets_wad_path = ProjectSettings.get_setting(
		"DOOM/settings/wad/wad_path_1",
		"res://addons/godot-doom-player/resources/wad/DOOM.WAD"
	)
	doom.assets_soundfont_path = ProjectSettings.get_setting(
		"DOOM/settings/soundfont/soundfont_path",
		"res://addons/godot-doom-player/resources/sf3/MuseScore_General.sf3"
	)


func init_doom() -> void:
	if doom == null or editor_interface == null:
		return

	update_paths()
	doom.import_assets()
	doom.grab_focus()


func kill_doom() -> void:
	if editor_interface == null:
		return

	doom.doom_enabled = false


func _on_size_option_button_item_selected(index: int) -> void:
	match index:
		0:
			doom.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		1:
			doom.stretch_mode = TextureRect.STRETCH_SCALE
