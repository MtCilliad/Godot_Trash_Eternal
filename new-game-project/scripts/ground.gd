extends Node2D
@onready var earth: ProgressBar = $CanvasLayer/Earth
@onready var bg1: Node2D = $Backgrounds/Game_Background_1
@onready var bg2: Node2D = $Backgrounds/Game_Background_2
@onready var bg3: Node2D = $Backgrounds/Game_Background_3
@onready var bg4: Node2D = $Backgrounds/Game_Background_4
@onready var sg1: AnimatedSprite2D = $Props/Sewage/Sewage1
@onready var sg2: AnimatedSprite2D = $Props/Sewage/Sewage2
@onready var sg3: AnimatedSprite2D = $Props/Sewage/Sewage3
@onready var event: Node2D = $Event
@onready var sfx_ground: AudioStreamPlayer = $Sfx_Ground

var timer

#days
var day : int
var day_timer : float
var day_interval : int

#event
var event_chance : float
var current_spawn_rate : float
var event_active : bool

#Ground
var _ground_hp : int
var _dmg_timer : float
var _dmg_interval : float
var _game_over := false

#Signals
signal game_over
signal brand_new_day(day_number : int)
signal trigger_event(trigger : String)

func _init() -> void:
	#event value assignment
	event_chance = 0.4
	current_spawn_rate = 1.0
	event_active = false
	
	#ground value assignmenet
	_ground_hp = 300
	_dmg_timer = 0.0
	_dmg_interval = 20.0
	
	#day value assignment
	day_timer = 0.0
	day_interval = 20
	
func _ready() -> void:
	add_to_group("ground")
	new_game()
	sfx_ground.play()
	earth.value = _ground_hp
	earth.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	take_damage(delta, "trash")
	new_day(delta)
		
func new_game():
	day = 1
	
func take_damage(sec_past : float, trash_group : String) -> void:
	_dmg_timer += sec_past
	if _dmg_timer >= _dmg_interval:
		_dmg_timer -= _dmg_interval
		var total := 0
		for trash_dmg in get_tree().get_nodes_in_group(trash_group):
			print(trash_dmg.dmg)
			total += trash_dmg.dmg
		_ground_hp = max(_ground_hp - total, 0)
		earth.value = _ground_hp
		if _ground_hp == 0:
			print("game over")
			earth.visible = false
			_game_over = true
			game_over.emit()	

func new_day(sec_past : float) -> void:
	if _game_over == false:
		day_timer += sec_past
		if day_timer >= day_interval:
			day_timer -= day_interval
			day += 1
			brand_new_day.emit(day)
			print("Day: ",day)
			if randf() < event_chance:
				event_active = true
				sfx_ground.stop()
				trigger_event.emit("Yes")
				print("Event triggered")
			else:
				if event_active:
					event_active = false
					sfx_ground.play() 
				trigger_event.emit("No")
				print("Event not triggered")
		if _ground_hp >= 225:
			change_state(true, false, false, false, "State1")
		elif _ground_hp >= 150 and _ground_hp <= 224:
			change_state(false, true, false, false, "State2")
		elif _ground_hp >= 75 and _ground_hp <= 149:
			change_state(false, false, true, false, "State3")
		elif _ground_hp >= 0 and _ground_hp <= 74:
			change_state(false, false, false, true, "State4")
		
func change_state(state1 : bool, state2 : bool, state3 : bool, state4 : bool, sewers : String):
	bg1.visible = state1
	bg2.visible = state2
	bg3.visible = state3
	bg4.visible = state4
	sg1.play(sewers)
	sg2.play(sewers)
	sg3.play(sewers)
