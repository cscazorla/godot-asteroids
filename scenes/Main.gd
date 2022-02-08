extends Node2D

# Exports
export (int) var initial_asteroids = 10
export (int) var seconds_to_spawn_health_power_up = 15

# Internal variables
var score
var screen_size

# Preloads
var Bullet = preload("res://scenes/Bullet.tscn")
var Asteroid = preload("res://scenes/Asteroid.tscn")
var PowerupHealth = preload("res://scenes/PowerupHealth.tscn")
var Player = preload("res://scenes/Player.tscn")
var HUD = preload("res://scenes/HUD.tscn")

func _ready():
	randomize()
	screen_size = get_viewport_rect().size
	if $Screens.connect("start_game", self, "new_game") != OK:
		print("Error connecting to the star game signal")

func new_game():
	score = 0
	create_player(100)
	create_hud()
	create_asteroids(initial_asteroids)
	create_powerups()

func create_player(life):
	var player = Player.instance()
	player.init(life)
	add_child(player)
	player.position.x = screen_size.x/2
	player.position.y = screen_size.y/2
		
	if $Player.connect("shoot", self, "_on_player_shoot") != OK:
		print("Error connecting to the player shoot signal")
	if $Player.connect("player_crashes_into_asteroid", self, "_on_player_crashes_into_asteroid") != OK:
		print("Error connecting to the player crashing into an asteroid signal")
	if $Player.connect("player_picks_up_health", self, "_on_player_picks_up_health") != OK:
		print("Error connecting to the player picking up health signal")
	if $Player.connect("gameover", self, "_on_gameover") != OK:
		print("Error connecting to the dissappear timeout signal")

func create_hud():
	add_child(HUD.instance())
	$HUD.update_score(score)
	$HUD.update_player_health_bar($Player.life)

func create_powerups():
	var spawn_health_powerup_timer = Timer.new()
	spawn_health_powerup_timer.set_wait_time(seconds_to_spawn_health_power_up)
	if spawn_health_powerup_timer.connect("timeout", self, "_on_spawn_powerup_timer_timeout") != OK:
		print("Error connecting to the health power-up dissappear timeout signal")
	add_child(spawn_health_powerup_timer)
	spawn_health_powerup_timer.start()

func clean_up_asteroids():
	var asteroids = get_tree().get_nodes_in_group("asteroids")
	for asteroid in asteroids:
		asteroid.queue_free()

func create_asteroids(amount):
	clean_up_asteroids()
	for i in amount:
		init_asteroid()

func init_asteroid():
	var a = Asteroid.instance()
	add_child(a)
	var x = rand_range(0, 1.0) * screen_size.x
	var y = rand_range(0, 1.0) * screen_size.y
	var linear_velocity = Vector2(rand_range(-1.0, 1.0) * 20, rand_range(-1.0, 1.0) * 20)
	var angular_velocity = rand_range(-1.0, 1.0)
	a.init(5, Vector2(x,y), linear_velocity, angular_velocity)

func destroy_resources():
	$HUD.queue_free()
	$Player.queue_free()

func _on_player_shoot(direction, location):
	var b = Bullet.instance()
	add_child(b)
	b.connect("hit_asteroid", self, "_on_player_shoot_hits_asteroid")
	b.init(direction, location)

func _on_player_shoot_hits_asteroid(asteroid):
	score += 10
	$HUD.update_score(score)
	if (asteroid.lifes > 1):
		var a1 = Asteroid.instance()
		var a2 = Asteroid.instance()
		add_child(a1)
		add_child(a2)
		a1.init(asteroid.lifes - 1, asteroid.position + Vector2(10,10), asteroid.linear_velocity.rotated(PI/4) * (3), asteroid.angular_velocity * (1.1))
		a2.init(asteroid.lifes - 1, asteroid.position - Vector2(10,10), asteroid.linear_velocity.rotated(-PI/4) * (3), asteroid.angular_velocity * (1.1))
	asteroid.queue_free()

func _on_player_crashes_into_asteroid(asteroid, shake_effect):
	$ShakeCamera.add_trauma(shake_effect)
	$HUD.update_player_health_bar($Player.life)
	asteroid.queue_free()	

func _on_player_picks_up_health(powerup_health):
	$HUD.update_player_health_bar($Player.life)
	powerup_health.queue_free()
	
func _on_gameover():
	destroy_resources()
	$Screens.game_over()

func _on_spawn_powerup_timer_timeout():
	var random_position = Vector2(rand_range(0, 1.0) * screen_size.x, rand_range(0, 1.0) * screen_size.y)
	var health_powerup = PowerupHealth.instance()
	add_child(health_powerup)
	health_powerup.position = random_position
