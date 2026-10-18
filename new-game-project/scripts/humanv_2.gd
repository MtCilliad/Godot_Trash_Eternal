extends Area2D
@onready var humanv_2: Area2D = $"."
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

#human
var speed : float
const start_speed : float = 1
const max_speed : int = 3
var human_direction : String 
var speed_multiplier := 1.0

#variation
var variation: Array[String] = ["Blue", "Brown", "Green", "Pink"]

#signals
signal roomba_touched

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_connect_to_event()
	animated_sprite_2d.flip_h = true
	var random_choice: String = variation.pick_random()
	animated_sprite_2d.play(random_choice)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	speed = start_speed
	
	if human_direction == "Right":
		humanv_2.position.x -= speed * speed_multiplier
	elif human_direction == "Left":
		animated_sprite_2d.flip_h = false
		humanv_2.position.x += speed * speed_multiplier

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Roomba":
		roomba_touched.emit()
		
func _connect_to_event() -> void:
	var event := get_tree().get_first_node_in_group("Event")
	if event:
		event.increase_spawn_rates.connect(_set_new_speed_rates)
		_set_new_speed_rates(event.current_spawn_rate)

func _set_new_speed_rates(amount : float) -> void:
	speed_multiplier = amount
