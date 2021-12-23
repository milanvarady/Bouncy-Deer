extends Node

var current_level: int = -1
var levels_unloced: int = 15
var stars_earned: int = 2
var stars: PoolIntArray
var move_phase := true

func go_to_level(level_num: int) -> void:
	Global.current_level = level_num
	get_tree().change_scene("res://Levels/Level%s.tscn" %  level_num)


enum TimeFormat {
	FORMAT_HOURS   = 1 << 0,
	FORMAT_MINUTES = 1 << 1,
	FORMAT_SECONDS = 1 << 2
}

func format_time(time, format = TimeFormat.FORMAT_MINUTES | TimeFormat.FORMAT_SECONDS, digit_format = "%02d"):
	var digits = []

	if format & TimeFormat.FORMAT_HOURS:
		var hours = digit_format % [time / 3600]
		digits.append(hours)

	if format & TimeFormat.FORMAT_MINUTES:
		var minutes = digit_format % [time / 60]
		digits.append(minutes)

	if format & TimeFormat.FORMAT_SECONDS:
		var seconds = digit_format % [int(ceil(time)) % 60]
		digits.append(seconds)

	var formatted = String()
	var colon = ":"

	for digit in digits:
		formatted += digit + colon

	if not formatted.empty():
		formatted = formatted.rstrip(colon)

	return formatted
