extends CanvasLayer
@onready var transition: AnimatedSprite2D = $AnimatedSprite2D
@onready var sfx_transition: AudioStreamPlayer = $Sfx_Transition

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	transition.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_ground_brand_new_day(day_number: int) -> void:
	transition.visible = true
	print("transition is playing")
	transition.play("default")
	sfx_transition.play()


func _on_ground_game_over() -> void:
	transition.visible = false
