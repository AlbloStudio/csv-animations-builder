@tool
class_name AnimationItem

var animation_name: String
var frame_coords_start: Vector2
var frame_size: Vector2
var frame_count: int
var frame_duration_ms: int
var region_size: Vector2
var loop_mode: Animation.LoopMode
var autoplay_on_load: bool
var length: float


func _init(animation_data: Dictionary) -> void:
	animation_name = animation_data[AnimationConsts.ROW_ANIMATION_NAME]

	frame_coords_start = Vector2(
		animation_data[AnimationConsts.ROW_FRAME_COORDS_START_X],
		animation_data[AnimationConsts.ROW_FRAME_COORDS_START_Y]
	)

	frame_size = Vector2(
		animation_data[AnimationConsts.ROW_FRAME_SIZE_X],
		animation_data[AnimationConsts.ROW_FRAME_SIZE_Y]
	)

	frame_count = animation_data[AnimationConsts.ROW_FRAME_COUNT]

	frame_duration_ms = animation_data[AnimationConsts.ROW_FRAME_DURATION_MS]

	loop_mode = (
		Animation.LOOP_LINEAR if animation_data[AnimationConsts.ROW_LOOP] else Animation.LOOP_NONE
	)

	autoplay_on_load = animation_data[AnimationConsts.ROW_AUTOPLAY_ON_LOAD]

	region_size = Vector2(frame_size.x * frame_count, frame_size.y)
	frame_coords_start.y -= frame_size.y
	length = frame_duration_ms * frame_count / 1000.0
