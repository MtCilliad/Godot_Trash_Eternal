extends Node2D
@onready var earth: ProgressBar = $CanvasLayer/Earth
@onready var bg1: Node2D = $Backgrounds/Game_Background_1
@onready var bg2: Node2D = $Backgrounds/Game_Background_2
@onready var bg3: Node2D = $Backgrounds/Game_Background_3
@onready var bg4: Node2D = $Backgrounds/Game_Background_4
@onready var sg1: AnimatedSprite2D = $Props/Sewage
@onready var sg2: AnimatedSprite2D = $Props/Sewage2
@onready var sg3: AnimatedSprite2D = $Props/Sewage3

var timer

#days(not implemented yet)
var day : int
var day_timer := 0.0
var day_interval := 30

#Ground
var ground_hp = 500
var dmg_timer := 0.0
var dmg_interval := 3.0

#Signals
signal game_over
signal brand_new_day(day_number : int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()
	earth.value = ground_hp

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	take_damage(delta, "trash")
	new_day(delta)
		
func new_game():
	day = 1
	
func take_damage(sec_past : float, trash_group : String) -> void:
	dmg_timer += sec_past
	if dmg_timer >= dmg_interval:
		dmg_timer -= dmg_interval
		var total := 0
		for trash_dmg in get_tree().get_nodes_in_group(trash_group):
			total += trash_dmg.dmg
		ground_hp = max(ground_hp - total, 0)
		earth.value = ground_hp
		if ground_hp == 0:
			print("game over")
			earth.visible = false
			game_over.emit()

func new_day(sec_past : float) -> void:
	day_timer += sec_past
	if day_timer >= day_interval:
		day_timer -= day_interval
		day += 1
		brand_new_day.emit(day)
		print("Day: ",day)
	if ground_hp >= 400:
		change_state(true, false, false, false, "State1")
	elif ground_hp >= 300 and ground_hp <= 399:
		change_state(false, true, false, false, "State2")
	elif ground_hp >= 200 and ground_hp <= 299:
		change_state(false, false, true, false, "State3")
	elif ground_hp >= 100 and ground_hp <= 199:
		change_state(false, false, false, true, "State4")
		
func change_state(state1 : bool, state2 : bool, state3 : bool, state4 : bool, sewers : String):
	bg1.visible = state1
	bg2.visible = state2
	bg3.visible = state3
	bg4.visible = state4
	sg1.play(sewers)
	sg2.play(sewers)
	sg3.play(sewers)
