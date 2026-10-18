extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera_2d: Camera2D = $Camera2D
@onready var sfx_moving: AudioStreamPlayer2D = $Sfx_Moving

const tower = preload("uid://8bdc0xc7bxau")

#roomba
const SPEED = 300.0
var roomba_facing := "Right"
#const JUMP_VELOCITY = -400.0
var score : int = 0

#camera
var zoom_min = Vector2(1.1, 1.1)
var zoom_max = Vector2(1.15, 1.5)
var zoom_speed = Vector2(0.0030,0.0030)

#signal
signal UI_score_display(score_val : int)
signal is_right(right : bool)

func _ready() -> void:
	add_to_group("roomba")
	connect_to_UI()

func _process(delta: float) -> void:
	spawn_tower()

func _physics_process(delta: float) -> void:
	var roomba_direction := Input.get_axis("Left", "Right")
	
	if roomba_direction > 0:
		roomba_facing = "Right"
	elif roomba_direction < 0:
		roomba_facing = "Left"
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# Handle jump.
	#if Input.is_action_just_pressed("Jump") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if roomba_direction:
		velocity.x = roomba_direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	if abs(velocity.x) > 1:
		animated_sprite_2d.play("Moving")
		animated_sprite_2d.flip_h = (roomba_facing == "Right")
		if camera_2d.zoom > zoom_min:
			camera_2d.zoom -= zoom_speed
	else:
		animated_sprite_2d.flip_h = false
		animated_sprite_2d.play(roomba_facing)  # "Right" or "Left" idle sprite
		if camera_2d.zoom < zoom_max:
			camera_2d.zoom += zoom_speed
			

func add_score(amount: int) -> void:
	score += amount
	UI_score_display.emit(score)
	print("Score: ", score)

func connect_to_UI() -> void:
	var UI = get_tree().get_first_node_in_group("UI")
	if UI:
		UI_score_display.connect(UI._display_score)
		
func spawn_tower() -> void:
	if Input.is_action_just_pressed("Build"):
		var turret = tower.instantiate()
		is_right.connect(turret._on_roomba_is_right, CONNECT_ONE_SHOT)
		get_tree().current_scene.add_child(turret)
		turret.global_position = global_position
		is_right.emit(roomba_facing == "Right")
		await get_tree().create_timer(20).timeout
		turret.queue_free()
