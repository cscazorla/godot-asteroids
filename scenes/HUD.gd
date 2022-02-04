extends CanvasLayer

func update_score(score):
	$ScoreLabel.text = "Score: " + str(score)

func update_player_health_bar(health):
	$HealthBar.value = health

func show_game_over_msg():
	$GameOverLabel.visible = true
