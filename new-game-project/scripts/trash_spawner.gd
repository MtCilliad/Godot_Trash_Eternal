extends Node2D
@onready var trash_cleaned: AudioStreamPlayer = $Trash_Cleaned

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
	_connect_to_event()

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
		
func _set_trash_spawn_rate(amount : float) -> void:
	trash_spawn_rate = amount
	
func set_new_spawn_rates(rates: float) -> void:
	_set_trash_spawn_rate(rates)
	print("new trash spawn rate: ",rates)

func _connect_to_event() -> void:
	var event := get_tree().get_first_node_in_group("Event")
	if event:
		event.increase_spawn_rates.connect(set_new_spawn_rates)
		set_new_spawn_rates(event.current_spawn_rate)
