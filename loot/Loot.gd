extends Area2D

signal collected

var velocity = Vector2()

func _ready():
	add_to_group('loot')

func _physics_process(delta):
	for body in get_overlapping_bodies():
		if body.name.find('Player') != -1 and self.visible:
			emit_signal('collected', self)
			self.hide()
