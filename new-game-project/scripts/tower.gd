extends Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var tower: Area2D = $"."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.play_audio("building", -5.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_roomba_is_right(right : bool):
	sprite_2d.flip_h = not right
