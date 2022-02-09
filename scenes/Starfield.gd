extends Node2D

export (int) var total_items = 20

export var textures = [
	preload("res://assets/PNG/Effects/star2.png"), 
]

var items = []
var screen_size

func _ready():
	randomize()
	screen_size = get_viewport_rect().size
	var max_height = int(screen_size.y)
	var total_textures = textures.size()
	for n in total_items:
		var x_offset = (randi() % 10) / 10.0
		var scale_size = (0.2 + (randi() % 5)/ 10.0)
		var modulation = (randi() % 8) / 10.0
		
		var spr = Sprite.new()
		spr.texture = textures[randi() % total_textures]
		spr.position = Vector2(screen_size.x * x_offset, randi() % max_height)
		spr.scale = Vector2.ONE * scale_size
		spr.modulate.a = modulation
		add_child(spr)
		items.push_back(spr)

func _physics_process(delta):
	for item in items:
		var speed_x = randi() % 10
		item.position += Vector2(-speed_x,0) * delta
		
		# World boundaries
		item.position.x = wrapf(item.position.x, 0, screen_size.x)
		item.position.y = wrapf(item.position.y, 0, screen_size.y)
