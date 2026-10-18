extends Node

#file handling
const save_file = "user://savefile.save"
var highest_record = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_score()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func save_score():
	var file = FileAccess.open(save_file, FileAccess.WRITE_READ)
	file.store_64(highest_record)

func load_score():
	var file = FileAccess.open(save_file, FileAccess.READ)
	if FileAccess.file_exists(save_file):
		highest_record = file.get_64()
