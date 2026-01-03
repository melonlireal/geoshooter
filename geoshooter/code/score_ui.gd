extends Control
var SCOREDIGIT = 10
# how many digit displayed score has
var score = 0
var score_displayed = 0
const SCORE_INCREMENT_SPEED := 25.0 # per second
var score_factor = 1
var tween: Tween = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if int($score.get_parsed_text()) < score:
		if !$AnimationPlayer.current_animation == "increase_score":
			$AnimationPlayer.play("increase_score")
	else:
		$AnimationPlayer.play("RESET")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func update_score(value: int):
	score += value * score_factor
	var tween_duration = (score - score_displayed) / SCORE_INCREMENT_SPEED
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_parallel()
	tween.tween_property(self, "score_displayed", score, tween_duration)
	tween.tween_method(func(_unused): $score.text = (
		"[center]"+ "0".repeat(SCOREDIGIT - len(str(score))) + "%d[/center]"%round(score_displayed)), 0, 0, tween_duration)
	
	pass
	
func update_factor(value: int):
	pass
