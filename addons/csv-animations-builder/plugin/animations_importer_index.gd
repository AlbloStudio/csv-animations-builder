@tool
class_name AnimationsImporterIndex extends EditorPlugin

const EDITOR_INSPECTOR = "res://addons/animations_importer/animations_importer_editor_inspector.gd"
const IMPORTER_RESOURCE = "res://addons/animations_importer/animations_importer_resource.gd"

var plugin: AnimationsImporterEditorInspector
var resource_plugin: AnimationsImporterResource


func _enter_tree() -> void:
	if Engine.is_editor_hint():
		plugin = preload(EDITOR_INSPECTOR).new()
		add_inspector_plugin(plugin)

		resource_plugin = preload(IMPORTER_RESOURCE).new()
		add_import_plugin(resource_plugin)


func _exit_tree() -> void:
	if Engine.is_editor_hint():
		remove_inspector_plugin(plugin)
		remove_import_plugin(resource_plugin)
