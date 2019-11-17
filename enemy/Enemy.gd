extends KinematicBody2D

signal collided

export var gravity = 2500
export var speed = 50  # Pixels per second

var velocity = Vector2()
var move_left = false
var move_right = false
var loop_animation = true

func _ready():
	add_to_group('enemy')
	$AnimatedSprite.connect('animation_finished', self, '_on_animation_finished')
	self.connect('collided', self, '_on_collided')

func start(start_position):
	position = start_position
	$AnimatedSprite.play()
	_move_left()

func _move_left():
	move_left = true
	move_right = false
	$AnimatedSprite.flip_h = true
	$CollisionShape2D.position.x = 10
	$AnimatedSprite.animation = 'walk'
	loop_animation = true
	
func _move_right():
	move_left = false
	move_right = true
	$AnimatedSprite.flip_h = false
	$CollisionShape2D.position.x = 0
	$AnimatedSprite.animation = 'walk'
	loop_animation = true
	
func attack_left():
	move_left = false
	move_right = false
	$AnimatedSprite.flip_h = true
	$CollisionShape2D.position.x = 10
	$AnimatedSprite.animation = 'attack'
	loop_animation = false
	
func attack_right():
	move_left = false
	move_right = false
	$AnimatedSprite.flip_h = false
	$CollisionShape2D.position.x = 0
	$AnimatedSprite.animation = 'attack'
	loop_animation = false
	
func _physics_process(delta):
	if move_left:
		velocity.x = -speed
	elif move_right:
		velocity.x = speed
	else:
		velocity.x = 0

	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2(0, -1))
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision:
			emit_signal('collided', collision, self)

func _on_animation_finished():
	if !loop_animation:
		$AnimatedSprite.stop()

func _on_collided(collision, enemy):
	if collision.collider is TileMap:
		if collision.normal.x == 1:
			_move_right()
		elif collision.normal.x == -1:
			_move_left()
