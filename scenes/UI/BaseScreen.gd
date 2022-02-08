extends CanvasLayer

onready var tween = $Tween
onready var buttons = get_tree().get_nodes_in_group("buttons")

func appear():
	for button in buttons:
		button.set_disabled(false)
	tween.interpolate_property(self, "offset:x", 1024, 0, 0.5, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.start()

func disappear():
	for button in buttons:
		button.set_disabled(true)
	tween.interpolate_property(self, "offset:x", 0, 1024, 0.5, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.start()
