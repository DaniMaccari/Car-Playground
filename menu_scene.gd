extends Control

var title_tween : Tween
var text_tween : Tween
@onready var menu_title : Sprite2D = $LetterIconFruitRush
@onready var start_text : Control = $menuText

func change_scene() -> void:
	title_tween = create_tween().set_loops()
	title_tween.set_trans(Tween.TRANS_LINEAR)
	title_tween.tween_property(menu_title, "position", menu_title.position + Vector2(0.0, -500.0), 0.4)
	
	text_tween = create_tween().set_loops()
	text_tween.set_trans(Tween.TRANS_LINEAR)
	text_tween.tween_property(start_text, "modulate", Color(1, 1, 1, 0), 0.1)
	
	
