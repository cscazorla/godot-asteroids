extends Area2D

# Player parameters
export (int) var max_life = 100
export (int) var life_steps = 10
export (int) var linear_thrust = 300
export (float) var linear_drag = 0.5
export (int) var angular_thrust = 5
export (float) var angular_drag = 0.5

# Signals
signal shoot(direction, location)
signal player_crashes_into_asteroid(asteroid, shake_effect)
signal player_picks_up_health(powerup_health)
signal gameover()

# Internal
var life
var net_linear_acceleration = Vector2()
var linear_acceleration = Vector2()
var linear_velocity = Vector2()
var net_angular_acceleration = 0
var angular_acceleration = 0
var angular_velocity = 0

# World
var screen_size

func _ready():
	screen_size = get_viewport_rect().size
	if connect("area_entered", self, "_on_area_entered") != OK:
		print("Error connecting to the area entered signal")

func init(_life):
	life = _life

func get_input():
	$ParticlesThrust.emitting = false
	angular_acceleration = 0
	linear_acceleration = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		angular_acceleration = angular_thrust
	if Input.is_action_pressed("ui_left"):
		angular_acceleration = -angular_thrust
	if Input.is_action_pressed("ui_up"):
		$ParticlesThrust.emitting = true
		linear_acceleration = Vector2(linear_thrust, 0).rotated(rotation)

func _input(event):
	if event.is_action_pressed("ui_select"):
		emit_signal("shoot", rotation, position + Vector2.RIGHT.rotated(rotation)*20)

func _physics_process(delta):
	get_input()
	
	# Linear movement
	net_linear_acceleration = linear_acceleration - linear_velocity * linear_drag
	linear_velocity += net_linear_acceleration * delta
	position += linear_velocity * delta
	
	# Angular movement
	net_angular_acceleration = angular_acceleration - angular_velocity * angular_drag
	angular_velocity += net_angular_acceleration * delta
	rotation += angular_velocity * delta
	
	# World boundaries
	position.x = wrapf(position.x, 0, screen_size.x)
	position.y = wrapf(position.y, 0, screen_size.y)

func decrease_life(amount):
	life -= amount
	if(life <= 0):
		emit_signal("gameover")

func increase_life(amount):
	life += amount
	life = clamp(life, 0, 100)
	
func _on_area_entered(area):
	if area.is_in_group("asteroids"):
		var shake_effect = 0
		var amount_to_decrease = (linear_velocity.length() / linear_thrust) * life_steps * 4
		if amount_to_decrease < (0.2 * max_life):
			shake_effect = 0.2
		elif amount_to_decrease >= (0.2 * max_life) && amount_to_decrease < (0.5 * max_life):
			shake_effect = 0.4
		else:
			shake_effect = 0.5
		decrease_life(amount_to_decrease)
		linear_velocity -= area.linear_velocity.normalized() * (linear_velocity.length() * 0.5)
		emit_signal("player_crashes_into_asteroid", area, shake_effect)
	if area.is_in_group("powerup_healths"):
		increase_life(life_steps)
		emit_signal("player_picks_up_health", area)
