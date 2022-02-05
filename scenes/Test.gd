extends Node2D

# Exports
export (int) var initial_asteroids = 8
export (int) var seconds_to_spawn_health_power_up = 15

# Internal variables
var score = 0
var screen_size

# Preloads
var Bullet = preload("res://scenes/Bullet.tscn")
var Asteroid = preload("res://scenes/Asteroid.tscn")
var PowerupHealth = preload("res://scenes/PowerupHealth.tscn")

func _ready():
	randomize()
	screen_size = get_viewport_rect().size
	
	# Setup signals
	$Player.connect("shoot", self, "_on_player_shoot")
	$Player.connect("player_crashes_into_asteroid", self, "_on_player_crashes_into_asteroid")
	$Player.connect("player_picks_up_health", self, "_on_player_picks_up_health")
	$Player.connect("gameover", self, "_on_gameover")
	$SpawnPowerUpTimer.connect("timeout", self, "_on_spawn_powerup_timer_timeout")

	# Setup HUD
	$HUD.update_score(score)
	$HUD.update_player_health_bar($Player.life)
	
	# Instantiate some asteroids
	init_asteroids(initial_asteroids)

	# Setup timer to spawn power-ups
	$SpawnPowerUpTimer.set_wait_time(seconds_to_spawn_health_power_up)
	$SpawnPowerUpTimer.start()

func init_asteroids(amount):
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

func _on_player_crashes_into_asteroid(asteroid):
	$ShakeCamera.add_trauma(0.5)
	$HUD.update_player_health_bar($Player.life)
	asteroid.queue_free()	

func _on_player_picks_up_health(powerup_health):
	$HUD.update_player_health_bar($Player.life)
	powerup_health.queue_free()
	
func _on_gameover():
	$HUD.show_game_over_msg()
	$Player.queue_free()

func _on_spawn_powerup_timer_timeout():
	print("Health spawn time ", OS.get_unix_time())
	var random_position = Vector2(rand_range(0, 1.0) * screen_size.x, rand_range(0, 1.0) * screen_size.y)
	var health_powerup = PowerupHealth.instance()
	add_child(health_powerup)
	health_powerup.position = random_position
