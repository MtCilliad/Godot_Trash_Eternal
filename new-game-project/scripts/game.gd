extends Node2D
@onready var ui: CanvasLayer = $UI

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#Signals
	
func _brand_new_day(day : int):
	ui.Days
