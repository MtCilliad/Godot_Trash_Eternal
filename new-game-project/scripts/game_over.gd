extends CanvasLayer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var final_score_display: Label = $Final_Score
@onready var sfx_game_over: AudioStreamPlayer = $Sfx_Game_Over

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	get_tree().paused = false
	final_score_display.visible = false
	final_score_display.text = "0"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_ground_game_over() -> void:
	print("Game over")
	sfx_game_over.play()
	visible = true
	get_tree().paused = true
	animated_sprite_2d.play("game_over")
	await get_tree().create_timer(3.0).timeout
	final_score_display.visible = true

func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_ui_send_final_score(final_score: int) -> void:
	var hold = str(final_score)
	final_score_display.text = hold
