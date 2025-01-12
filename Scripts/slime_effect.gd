extends Control
var slime_tween : Tween

func _ready() -> void:
	$Sprite2D.modulate.a = 0.0
	$Sprite2D.show()

func show_slime() -> void:
	$Sprite2D.rotation_degrees += 180
	$Sprite2D.modulate.a = 1.0
	
	await get_tree().create_timer(1.0).timeout
	slime_tween = create_tween()
	slime_tween.set_trans(Tween.TRANS_LINEAR)
	slime_tween.tween_property($Sprite2D, "modulate:a", 0.0, 2.5)
