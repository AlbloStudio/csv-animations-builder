# my_inspector_plugin.gd
@tool
class_name AnimationsImporterEditorInspector extends EditorInspectorPlugin

const CATEGORY := "animations_importer.gd"

var editor = preload("res://addons/animations_importer/control/animations_importer_node.tscn")


func _can_handle(object: Object) -> bool:
	return (
		object is AnimationsImporter
		&& object.get_parent()
		&& object.get_parent() is AnimationPlayer
	)


func _parse_category(object: Object, category: String) -> void:
	if category != CATEGORY || !object || !object is AnimationsImporter:
		return

	var control = editor.instantiate()
	control.csv_resource = object.csv_resource
	object.csv_changed.connect(_set_csv_resource.bind(control, object))
	control.tree_exited.connect(_disconnect.bind(control, object))
	control.animation_player_parent = object.get_parent()
	add_custom_control(control)


func _set_csv_resource(control, object) -> void:
	control.csv_resource = object.csv_resource


func _disconnect(control, object) -> void:
	object.csv_changed.disconnect(_set_csv_resource.bind(control, object))
