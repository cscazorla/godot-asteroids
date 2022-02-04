extends Area2D

export (int) var lifes = 10
export (Vector2) var linear_velocity = Vector2(5,5)
export (float) var angular_velocity = 1
export (float) var max_linear_velocity_magnitude = 100

# World
var screen_size

func _ready():
	screen_size = get_viewport_rect().size

func init(with_lifes, location, lin_vel, ang_vel):
	lifes = with_lifes
	position = location
	if(lin_vel.length() > max_linear_velocity_magnitude):
		linear_velocity = lin_vel.normalized() * max_linear_velocity_magnitude
	else:
		linear_velocity = lin_vel
	
	angular_velocity = ang_vel

func _physics_process(delta):
	position += linear_velocity * delta
	rotation += angular_velocity * delta

	# World boundaries
	position.x = wrapf(position.x, 0, screen_size.x)
	position.y = wrapf(position.y, 0, screen_size.y)
