extends Area2D
class_name Trash

@onready var trash: Area2D = $"."
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var nearby: Area2D = $Nearby
@onready var sfx_cleaned: AudioStreamPlayer = $Sfx_Cleaned
@export var health: ProgressBar
@export var nearby_trash: Area2D 

var trash_xp = 0
var roomba_enter := false
var checking := true
const trash_level_max = 22
var trash_is_max := false
var is_pile := false
var variation : Array = ["Var1", "Var2"]
var chosen = variation.pick_random()

@export var hp = 10 : set = _set_health
@export var dmg = 1
@export var xp_given = 1
@export var score_give = 100 : set = _set_score

signal trash_detected(trash: Area2D, if_full: bool)
signal trash_dmg(damage)
signal give_score(score : int)

func _init() -> void:
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("trash")
	connect_to_roomba()
	var max_hp = hp
	if health:
		health.max_value = max_hp
		health.value = hp
	await get_tree().create_timer(0.1).timeout
	checking = false
	animated_sprite_2d.play(chosen)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func gain_xp(amount: int) -> void:
	if not level_is_max():
		trash_xp += amount
		become_pile()
		print("trash at pos ", trash.position.x," | ",trash_xp)
		level_is_max()
		level_up()
	else:
		print("Trash is at max already")

func level_is_max() -> bool:
	if trash_xp >= trash_level_max:
		trash_is_max = true
	else:
		trash_is_max = false
	return trash_is_max

func level_up() -> void:
	if trash_xp >= trash_level_max:
		animated_sprite_2d.play("lvl4")
		print("trash now at lvl 4")
		#dmg = 4 + dmg
		hp += 10
		health.max_value = hp
	elif trash_xp >= 12:
		animated_sprite_2d.play("lvl3")
		print("trash now at lvl 3")
		#dmg = 3 + dmg
		hp += 10
		health.max_value = hp
	elif trash_xp >= 5:
		animated_sprite_2d.play("lvl2")
		print("trash now at lvl 2")
		#dmg = 2 + dmg
		hp += 10
		health.max_value = hp
	else:
		animated_sprite_2d.play("lvl1")
		print("trash now at lvl 1")
func _set_health(new_value : int):
	hp = new_value
	if health:
		health.value = hp
		
func _set_score(new_value : int):
	score_give = new_value
		
func roomba_touched():
	roomba_enter = true
	while(hp > 0 and roomba_enter):
		hp -= 5
		print("hit, hp = ", hp)
		await get_tree().create_timer(0.5).timeout
	if hp == 0:
		trash.queue_free()
		play_cleaned()
		give_score.emit(score_give)

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	print(body.name)
	if body.name == "Roomba":
		roomba_touched()		

func _on_area_entered(area: Area2D) -> void:
	print("Check if this is the area",area.name)
		
func _on_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Roomba":
		roomba_enter = false	
			
func _on_nearby_area_entered(area: Area2D) -> void:
	if area == self or not area.is_in_group("trash"):
		return
	if not "checking" in area:
		return
		
	if checking:
		trash_detected.emit(self, area.trash_is_max)
	elif area.checking:
		gain_xp(xp_given)		
		
func become_pile() -> void:
	if is_pile:
		return
	is_pile = true

func connect_to_roomba():
	var roomba = get_tree().get_first_node_in_group("roomba")
	if roomba:
		give_score.connect(roomba.add_score)

func play_cleaned() -> void:
	sfx_cleaned.play()
