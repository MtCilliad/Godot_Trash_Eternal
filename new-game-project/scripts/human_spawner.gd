extends Node2D

#humans
var human_scene = preload("res://scenes/humanv_2.tscn")
var humans : Array
var human_direction
var human_timer : float = 0.0 #for spawning
var human_spawn_interval : float = 5.0
var human_spawn_rate : float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	human_timer += delta * human_spawn_rate
	if human_timer >= human_spawn_interval:
		print("Spawned")
		human_timer -= human_spawn_interval
		generate_human()
	
	for hums in humans:
		if hums.position.x < (-2100) or hums.position.x > (3400):
			kill_human(hums)

func kill_human(hums):
	hums.queue_free()
	humans.erase(hums)
	print("humans killed")
		
func generate_human():
	var hums = human_scene
	hums = hums.instantiate()
	if randi() % 2 == 0:
		hums.human_direction = "Right"
	else:
		hums.human_direction = "Left"
		
	add_hums(hums)

func add_hums(hums):
	if hums.human_direction == "Right":
		hums.position = Vector2i(randf_range(2600, 3300),613)
	else:
		hums.position = Vector2i(randf_range(-2000, -1100),613)
	add_child(hums)
	hums.roomba_touched.connect(_on_humanv_2_roomba_touched)
	print(hums.position.x)
	humans.append(hums)
	
#signals
func _on_humanv_2_roomba_touched() -> void:
	print("testing")

func set_human_spawn_rate(rates : float):
	human_spawn_rate = rates
	print("new human spawn rate: ",rates)

func _on_event_increase_spawn_rates(rates: float) -> void:
	set_human_spawn_rate(rates)
	print("set spawn rates on human")
