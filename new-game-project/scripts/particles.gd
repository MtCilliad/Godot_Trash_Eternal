extends CanvasLayer
@onready var particles1: CPUParticles2D = $CPUParticles2D
@onready var particles2: CPUParticles2D = $CPUParticles2D2
@onready var particles3: CPUParticles2D = $CPUParticles2D3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	particles1.emitting = false
	particles2.emitting = false
	particles3.emitting = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("Jump"):
		particles1.emitting = true
		particles2.emitting = true
		particles3.emitting = true
