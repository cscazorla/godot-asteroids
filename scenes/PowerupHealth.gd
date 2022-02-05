extends Area2D

var seconds_to_dissapear = 8

func _ready():
	if $DissappearTime.connect("timeout", self, "_on_dissappear_timeout") != OK:
		print("Error connecting to the dissappear timeout signal")
	$DissappearTime.start(seconds_to_dissapear)

func _on_dissappear_timeout():
	$AnimationPlayer.play("dissappear")
	yield($AnimationPlayer, "animation_finished")
	queue_free()
