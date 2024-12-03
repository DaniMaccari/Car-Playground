extends Control

var max_score : int = 0

var photo_tween : Tween
var text_tween : Tween
#const TEXT_COLOR : Color = Color(1.0, 1.0, 1.0, 1.0)
#const PHOTO_POS : Vector2 = Vector2()
var start_tween : Tween

func change_scene() -> void:
	photo_tween = create_tween()
	photo_tween.set_trans(Tween.TRANS_LINEAR)
	photo_tween.tween_property($endPhoto, "position", $endPhoto.position + Vector2(0.0, -500.0), 0.4)
	
	text_tween = create_tween()
	text_tween.set_trans(Tween.TRANS_LINEAR)
	text_tween.tween_property($endText, "modulate:a", 0.0, 0.1)

func set_score(new_score : int) -> void:
	# put everything in place
	$endText.modulate.a = 1.0
	$endPhoto.position = Vector2.ZERO
	
	start_tween = create_tween().set_loops()
	start_tween.TRANS_ELASTIC
	start_tween.tween_property($endText/StartLabel, "modulate:a", 0.4, 1.0)
	start_tween.tween_property($endText/StartLabel, "modulate:a", 1.0, 1.5)
	
	show()
	
	if new_score > max_score:
		max_score = new_score
	
	$endText/FinalScore.clear()
	$endText/FinalScore.append_text("[center]%03d" % new_score)
	$endText/MaxScoreText.clear()
	$endText/MaxScoreText.append_text("[center]your max %03d" % max_score)
