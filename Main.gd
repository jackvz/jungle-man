extends Node2D

export (PackedScene) var Player
export (PackedScene) var Enemy

var score = 0
var player
var audio_player
var audio_player2

func _ready():
	var camera = Camera2D.new()
	camera.make_current()
	camera.position = $Level1/PlayerStartPosition.position
	camera.limit_bottom = 480
	self.add_child(camera)

	audio_player = AudioStreamPlayer.new()
	self.add_child(audio_player)
	audio_player2 = AudioStreamPlayer.new()
	self.add_child(audio_player2)

	$HUD.connect('start_game', self, 'new_game')

func new_game():
	score = 0
	$HUD.update_score(score)

	audio_player.stream = load('res://audio/04forest3.wav')
	audio_player.play()

	# Clear and create the player
	if player:
		player.queue_free()
	player = Player.instance()
	player.name = 'Player'
	player.add_to_group('loot')
	add_child(player)
	player.start($Level1/PlayerStartPosition.position)
	player.connect('collided', self, '_on_player_collided')

	# Clear and create the enemies
	for enemy in get_tree().get_nodes_in_group('enemy'):
		enemy.queue_free()
	for enemy_start_position in get_tree().get_nodes_in_group('enemy_start_position'):
		var enemy = Enemy.instance()
		add_child(enemy)
		enemy.start(enemy_start_position.position)
		enemy.connect('collided', self, '_on_enemy_collided')
	
	# Set/reset the loot
	for loot in get_tree().get_nodes_in_group('loot'):
		loot.show()
		loot.connect('collected', self, '_on_loot_collected')

func game_over():
	player.die()
	$HUD.show_game_over()
	audio_player.stream = load('res://audio/13gameover1V1NL.wav')
	audio_player.play()

func _process(delta):
	if player:
		var player_pos = $Level1/TileMap.world_to_map(player.position)
		if player_pos.y > 100 and player.is_active:
			game_over()
		# print('Player: ' + str(player_pos))
	# var pointer_pos = $Level1/TileMap.world_to_map(get_global_mouse_position())
	# print('Pointer: ' + str(pointer_pos))
	
func _on_player_collided(collision):
	if collision.collider.name.find('Enemy') != -1:
		if collision.normal.x > 0:
			collision.collider.attack_right()
		else:
			collision.collider.attack_left()
		game_over()

func _on_enemy_collided(collision, enemy):
	if collision.collider.name == 'Player':
		if collision.normal.x > 0:
			enemy.attack_left()
		else:
			enemy.attack_right()
		game_over()

func _on_loot_collected(item):
	score += 1
	$HUD.update_score(score)

	# Win
	if item.name.find('TreasureSack') != -1 and player.is_active:
		player.win()
		$HUD.show_win()

		audio_player.stream = load('res://audio/12win1NL.wav')
		audio_player.play()

		for enemy in get_tree().get_nodes_in_group('enemy'):
			enemy.queue_free()
	else:
		audio_player2.stream = load('res://audio/14short3NL.wav')
		audio_player2.play()
