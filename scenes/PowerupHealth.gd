extends Area2D

var seconds_to_dissapear = 8

func _ready():
	$DissappearTime.connect("timeout", self, "_on_dissappear_timeout")
	$DissappearTime.start(seconds_to_dissapear)

func _on_dissappear_timeout():
	$AnimationPlayer.play("dissappear")
	yield($AnimationPlayer, "animation_finished")
	queue_free()
