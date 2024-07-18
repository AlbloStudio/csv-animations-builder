@tool
class_name AnimationsImporter extends Node

signal csv_changed

@export var csv_resource: CSVResource:
	set(value):
		csv_resource = value
		csv_changed.emit()
