extends Node2D

const trash_scene = [
	preload("uid://mlrbcbhbn4hq"),
	preload("uid://bbmdg2vbj2v6c"),
	preload("uid://bcaxjoaon1crh"),
	#preload("uid://cjahwre1kv70c")
]
var trash_timer : float = 0.0
var trash_spawn_interval : float = 2.0
var trash_spawn_rate : float = 1.0
var trash_spawn_chance : float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	trash_timer += delta * trash_spawn_rate
	if trash_timer >= trash_spawn_interval:
		trash_timer -= trash_spawn_interval
		if randf() < trash_spawn_chance:
			_generate_trash()

func _generate_trash():
	var trash = trash_scene.pick_random().instantiate()
	get_tree().current_scene.add_child(trash)
	trash.trash_detected.connect(_on_trash_trash_detected)
	trash.global_position = global_position
	print("Trash spawned at: ",trash.position.x)
	_check_outside(trash)

func _check_outside(trash):
	if trash.position.x > 2475 or trash.position.x < -950:
		print("trash outside at: ",trash.position.x)
		trash.queue_free()

func _on_trash_trash_detected(trash, max) -> void:
	if not max:
		print("Trash deleted")
		trash.queue_free()
	else:
		print("Trash not full yet")
		return
