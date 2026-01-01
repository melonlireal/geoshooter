extends Control
var SCOREDIGIT = 10
# how many digit displayed score has
var score = 0
var score_factor = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func update_score(value: int):
	score += value * score_factor
	#var new_text:String = "0".repeat(SCOREDIGIT - len(str(score))) + str(score)
	#var tween:Tween = get_tree().create_tween().bind_node($score)
	#tween.tween_property($score, "text", new_text, 0.20)
	pass
	
func update_factor(value: int):
	pass


func _on_add_score_timer_timeout() -> void:
	if int($score.get_parsed_text()) < score:
		if !$AnimationPlayer.current_animation == "increase_score":
			$AnimationPlayer.play("increase_score")
		$score.text = "[center]" \
		+ "0".repeat(SCOREDIGIT - len(str(score))) + \
		str(int($score.get_parsed_text()) + 1) + "[/center]" 
		# add rich text label back
	else:
		$AnimationPlayer.play("RESET")
		# keep adding until final score is reached
