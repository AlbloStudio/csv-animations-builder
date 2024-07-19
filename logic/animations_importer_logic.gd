@tool
class_name AnimationsImporterLogic

signal on_log_info(message: String)

var animation_player: AnimationPlayer
var animation_info_csv: CSVResource


func _init(
	incoming_animation_player: AnimationPlayer, incoming_animation_info_csv: CSVResource
) -> void:
	animation_player = incoming_animation_player
	animation_info_csv = incoming_animation_info_csv


func set_animations_in_player() -> void:
	if !animation_player:
		return

	var animation_library := AnimationLibrary.new()

	for animation_data: Dictionary in animation_info_csv.records:
		var animation_item := AnimationItem.new(animation_data)
		if animation_library.has_animation(animation_item.animation_name):
			on_log_info.emit(
				"Animation already exists, discarding: %s\n" % animation_item.animation_name
			)
		else:
			var animation := _create_animation(animation_item)
			animation_library.add_animation(animation_item.animation_name, animation)
			on_log_info.emit("Animation created\n")

	_add_animations_to_player(animation_library)

	on_log_info.emit("Animations added to player")


func _create_animation(animation_item: AnimationItem) -> Animation:
	var animation := Animation.new()
	animation.length = animation_item.length

	on_log_info.emit("*******  %s *******" % animation_item.animation_name)
	on_log_info.emit("Creating animation")

	if animation_item.autoplay_on_load:
		animation_player.autoplay = animation_item.animation_name

	_add_region_rect(animation, animation_item)
	_add_hframes(animation, animation_item)
	_add_frame(animation, animation_item)

	return animation


func _add_region_rect(animation: Animation, animation_item: AnimationItem) -> void:
	var track_index_region_rect := animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(track_index_region_rect, ".:region_rect")
	(
		animation
		. track_insert_key(
			track_index_region_rect,
			0,
			Rect2(animation_item.frame_coords_start, animation_item.region_size),
		)
	)
	animation.value_track_set_update_mode(track_index_region_rect, Animation.UPDATE_DISCRETE)


func _add_hframes(animation: Animation, animation_item: AnimationItem) -> void:
	var track_index_frames := animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(track_index_frames, ".:hframes")
	animation.track_insert_key(track_index_frames, 0, animation_item.frame_count)
	animation.value_track_set_update_mode(track_index_frames, Animation.UPDATE_DISCRETE)


func _add_frame(animation: Animation, animation_item: AnimationItem) -> void:
	var track_index_frame := animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(track_index_frame, ".:frame")
	animation.value_track_set_update_mode(track_index_frame, Animation.UPDATE_DISCRETE)
	for i in range(animation_item.frame_count):
		animation.track_insert_key(
			track_index_frame, animation_item.frame_duration_ms * i / 1000.0, i
		)


func _add_animations_to_player(new_animation_library: AnimationLibrary) -> void:
	on_log_info.emit("Adding to player...")

	if !animation_player.has_animation_library(""):
		on_log_info.emit("Global Animation Library not founf, adding new one")
		animation_player.add_animation_library("", new_animation_library)
	else:
		on_log_info.emit("Global Animation Library found, adding animations to it")
		var original_library := animation_player.get_animation_library("")
		for animation_name in original_library.get_animation_list():
			original_library.remove_animation(animation_name)
			on_log_info.emit("Removed animation: %s" % animation_name)
		for animation_name in new_animation_library.get_animation_list():
			original_library.add_animation(
				animation_name, new_animation_library.get_animation(animation_name)
			)
			on_log_info.emit("Added animation to player: %s" % animation_name)
