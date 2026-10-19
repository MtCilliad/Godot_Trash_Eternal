extends Node

#file handling
const save_file = "user://savefile.save"
var _highest_record = 0

func _ready() -> void:
	load_score()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func save_score():
	var file = FileAccess.open(save_file, FileAccess.WRITE_READ)
	file.store_64(_highest_record)

func load_score():
	var file = FileAccess.open(save_file, FileAccess.READ)
	if FileAccess.file_exists(save_file):
		_highest_record = file.get_64()

func set_highest_record(amount : int) -> void:
	_highest_record = amount
	
func get_highest_record() -> int:
	return _highest_record
