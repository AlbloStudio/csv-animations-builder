# File from timothyqiu csv data importer:
# https://github.com/timothyqiu/godot-csv-data-importer

@tool
class_name AnimationsImporterResource extends EditorImportPlugin

enum Presets { CSV, CSV_HEADER }
enum Delimiters { COMMA, SEMICOLON, TAB }


func _get_importer_name():
	return "com.alblo.godot-csv-importer"


func _get_visible_name():
	return "CSV Data"


func _get_priority():
	return 2.0


func _get_import_order():
	return 0


func _get_recognized_extensions():
	return ["csv"]


func _get_save_extension():
	return "res"


func _get_resource_type():
	return "Resource"


func _get_preset_count():
	return Presets.size()


func _get_preset_name(preset):
	match preset:
		Presets.CSV:
			return "CSV"
		Presets.CSV_HEADER:
			return "CSV with headers"
		_:
			return "Unknown"


func _get_import_options(_path, preset):
	var delimiter = Delimiters.COMMA
	var headers = preset == Presets.CSV_HEADER

	return [
		{
			name = "delimiter",
			default_value = delimiter,
			property_hint = PROPERTY_HINT_ENUM,
			hint_string = "Comma,Semicolon,Tab"
		},
		{name = "headers", default_value = headers},
		{name = "detect_numbers", default_value = false},
		{name = "force_float", default_value = true},
	]


func _get_option_visibility(_path, _option, _options):
	return true


func _import(source_file, save_path, options, _platform_variants, _gen_files):
	var delim: String

	match options.delimiter:
		Delimiters.COMMA:
			delim = ","
		Delimiters.SEMICOLON:
			delim = ";"
		Delimiters.TAB:
			delim = "\t"

	var file = FileAccess.open(source_file, FileAccess.READ)
	if not file:
		printerr("Failed to open file: ", source_file)
		return FAILED

	var lines = []
	while not file.eof_reached():
		var line = file.get_csv_line(delim)
		if options.detect_numbers and (not options.headers or lines.size() > 0):
			var detected := []
			for field in line:
				field = field.strip_edges()
				if field == "true":
					detected.append(true)
				elif field == "false":
					detected.append(false)
				elif not options.force_float and field.is_valid_int():
					detected.append(int(field))
				elif field.is_valid_float():
					detected.append(float(field))
				else:
					detected.append(field)
			lines.append(detected)
		else:
			var detected := []
			for s in Array(line):
				detected.append(s.strip_edges())
			lines.append(detected)
	file.close()

	if not lines.is_empty() and lines.back().size() == 1 and lines.back()[0] == "":
		lines.pop_back()

	var data = preload("csv_data.gd").new()

	if options.headers:
		if lines.is_empty():
			printerr("Can't find header in empty file")
			return ERR_PARSE_ERROR

		var headers = lines[0]
		for i in range(1, lines.size()):
			var fields = lines[i]
			if fields.size() > headers.size():
				printerr("Line %d has more fields than headers" % i)
				return ERR_PARSE_ERROR
			var dict = {}
			for j in headers.size():
				var name = headers[j]
				var value = fields[j] if j < fields.size() else null
				dict[name] = value
			data.records.append(dict)
	else:
		data.records = lines

	var filename = save_path + "." + _get_save_extension()
	var err = ResourceSaver.save(data, filename)
	if err != OK:
		printerr("Failed to save resource: ", err)
	return err
