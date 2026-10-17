extends Node2D
@onready var par1: CPUParticles2D = $Particles/CPUParticles2D3
@onready var par2: CPUParticles2D = $Particles/CPUParticles2D4
@onready var par3: CPUParticles2D = $Particles/CPUParticles2D5
@onready var par4: CPUParticles2D = $Particles/CPUParticles2D6

var set_spawn_rates := 2.0
var current_spawn_rate := default
const default := 1.0


signal increase_spawn_rates(amount : float)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("Event")
	_set_emitting(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_ground_trigger_event(trigger : String) -> void:
	if trigger == "Yes":
		current_spawn_rate = set_spawn_rates
		increase_spawn_rates.emit(set_spawn_rates)
		print("setting spawn rate")
		_set_emitting(true)
	else:
		current_spawn_rate = default
		increase_spawn_rates.emit(default)
		print("not setting spawn rate")
		_set_emitting(false)

func _set_emitting(emit : bool):
	par1.emitting = emit
	par2.emitting = emit
	par3.emitting = emit
	par4.emitting = emit
