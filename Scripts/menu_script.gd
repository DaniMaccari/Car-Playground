extends Control

var title_tween : Tween
var text_tween : Tween
#@onready var menu_title : Sprite2D = $LetterIconFruitRush
#@onready var menu_text : Control = $menuText

var start_tween : Tween
#@onready var start_text : RichTextLabel = $menuText/StartLabel

func change_scene() -> void:
	title_tween = create_tween()
	title_tween.set_trans(Tween.TRANS_LINEAR)
	title_tween.tween_property($LetterIconFruitRush, "position", $LetterIconFruitRush.position + Vector2(0.0, -500.0), 0.4)
	
	text_tween = create_tween().set_loops()
	text_tween.set_trans(Tween.TRANS_LINEAR)
	text_tween.tween_property($menuText, "modulate:a", 0.0, 0.1)
	
func _ready() -> void:
	start_tween = create_tween().set_loops()
	start_tween.TRANS_ELASTIC
	start_tween.tween_property($menuText/StartLabel, "modulate:a", 0.4, 0.8)
	start_tween.tween_property($menuText/StartLabel, "modulate:a", 1.0, 1.2)
	
	
