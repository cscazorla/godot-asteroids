extends Area2D

func _ready():
	$DissappearTime.connect("timeout", self, "_on_dissappear_timeout")

func _on_dissappear_timeout():
	$AnimationPlayer.play("dissappear")
	yield($AnimationPlayer, "animation_finished")
	queue_free()
