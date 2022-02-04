extends Area2D

var velocity = Vector2.RIGHT
var speed = 300

# Signals
signal hit_asteroid(asteroid)

func _ready():
	$VisibilityNotifier2D.connect("screen_exited", self, "_on_VisibilityNotifier2D_screen_exited")
	connect("area_entered", self, "_on_area_entered")
	
func init(direction, location):
	rotation = direction
	position = location
	velocity = velocity.rotated(direction)

func _physics_process(delta):
	position += velocity * speed * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_area_entered(area):
	if area.is_in_group("asteroids"):
		emit_signal("hit_asteroid", area)
		queue_free()
