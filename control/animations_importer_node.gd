@tool
class_name AnimationsImporterNode extends VBoxContainer

var csv_resource: CSVResource:
	set(value):
		csv_resource = value
		_set_animations_info()

var animation_player_parent: AnimationPlayer

@onready var button := %ImportButton as Button
@onready var tree := %InfoTree as Tree
@onready var info := %Info as RichTextLabel


func _ready() -> void:
	button.pressed.connect(_set_animations_in_player)

	_set_animations_info()


func _setup_animations_info() -> void:
	tree.columns = 5
	tree.column_titles_visible = true
	var item1 = tree.create_item()
	var root = tree.create_item()
	tree.hide_root = true

	tree.set_column_title(0, "Name")
	tree.set_column_title(1, "Coords")
	tree.set_column_title(2, "Size")
	tree.set_column_title(3, "Frames")
	tree.set_column_title(4, "Frame Duration")


func _set_animations_info() -> void:
	if !tree:
		return

	tree.clear()
	if !csv_resource:
		return

	_setup_animations_info()

	for row in csv_resource.records:
		var item = tree.create_item()
		item.set_text(0, row[AnimationConsts.ROW_ANIMATION_NAME])
		item.set_text(
			1,
			str(
				Vector2(
					row[AnimationConsts.ROW_FRAME_COORDS_START_X],
					row[AnimationConsts.ROW_FRAME_COORDS_START_Y]
				)
			)
		)
		item.set_text(
			2,
			str(
				Vector2(
					row[AnimationConsts.ROW_FRAME_SIZE_X], row[AnimationConsts.ROW_FRAME_SIZE_Y]
				)
			)
		)
		item.set_text(3, str(row[AnimationConsts.ROW_FRAME_COUNT]))
		item.set_text(4, str(row[AnimationConsts.ROW_FRAME_DURATION_MS]))


func _set_animations_in_player() -> void:
	if !csv_resource:
		info.text = "No CSV resource provided. Set it in the field below."
		return

	info.text = ""
	var animations_importer_logic = AnimationsImporterLogic.new(
		animation_player_parent, csv_resource
	)
	animations_importer_logic.on_log_info.connect(_on_log_info)
	animations_importer_logic.set_animations_in_player()


func _on_log_info(message: String) -> void:
	info.text += message + "\n"
