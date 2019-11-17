extends KinematicBody2D

signal collided

export var gravity = 2500
export var speed = 300 # Pixels per second
export var jump = -900

var jumping = false
var is_active = true
var velocity = Vector2()

func _ready():
	pass
	
func start(start_position):
	position = start_position
	$AnimatedSprite.play()

func _physics_process(delta):
	velocity.x = 0
	velocity.y += gravity * delta

	if is_active:
		jumping = false
		if Input.is_action_pressed('ui_right'):
			velocity.x += 1
		if Input.is_action_pressed('ui_left'):
			velocity.x -= 1
		velocity.x *= speed
		if Input.is_action_just_pressed('ui_select'):
			jumping = true

	velocity = move_and_slide(velocity, Vector2(0, -1))

	if is_active:
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			if collision:
				emit_signal('collided', collision)
	
		if is_on_floor() and jumping:
			velocity.y = jump
	
		if velocity.y != 0 and velocity.y < 0:
			$AnimatedSprite.animation = 'jump'
		elif velocity.x != 0:
			$AnimatedSprite.animation = 'run'
			$AnimatedSprite.flip_v = false
			$AnimatedSprite.flip_h = velocity.x < 0
		elif velocity.y != 0 and velocity.y > 0:
			$AnimatedSprite.animation = 'landing'
		else:
			$AnimatedSprite.animation = 'idle'

func die():
	is_active = false
	$AnimatedSprite.animation = 'mid-air'

func win():
	is_active = false
	$AnimatedSprite.animation = 'jump'
