extends CanvasLayer

signal start_game

func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()

func show_game_over():
	show_message('Game Over')
	yield($MessageTimer, 'timeout')
	$StartButton.show()

func show_win():
	$MessageLabel.text = 'You Win!'
	$MessageLabel.show()

func update_score(score):
	$ScoreLabel.text = 'Score: ' + str(score)

func _on_StartButton_pressed():
    $StartButton.hide()
    emit_signal('start_game')

func _on_MessageTimer_timeout():
    $MessageLabel.hide()
