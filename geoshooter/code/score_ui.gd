extends Control
var SCOREDIGIT = 10
# how many digit displayed score has
var score = 0
var score_displayed = 0
const SCORE_INCREMENT_SPEED := 25.0 # per second
var display_speed = 1
var score_factor = 1 
var score_factor_progress = 0
var curr_score_factor_req = 1

var tween: Tween = null
var mus_tween: Tween = null
var ene_tween: Tween = null

@onready var trigene_UI = $HBoxContainer/trienergy
@onready var squene_UI = $HBoxContainer/squenergy
@onready var penene_UI = $HBoxContainer/penenergy
@onready var score_UI = $score
@onready var score_factor_UI = $scorefactor
@onready var progress_bar = $ProgressBar
@onready var music_cur = $music/curr_mus
@onready var music_sta = $music/start_mus
@onready var music_int = $music/mid_mus
@onready var music_ten = $music/ten_mus
@onready var musics = [music_sta, music_int, music_ten]

signal rock
signal end_rock
signal spawn_player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	score_factor_UI.text = ("[center]X%d[/center]" %score_factor)
	music_cur.play()

func start_game():
	self.visible = true
	$gameover.visible = false
	$restart.visible = false
	$restart.disabled = true
	
func end_game():
	$gameover.visible = true
	$restart.visible = true
	$restart.disabled = false

func _process(_delta: float) -> void:
	if int(score_UI.get_parsed_text()) < score:
		if !$AnimationPlayer.current_animation == "increase_score":
			$AnimationPlayer.play("increase_score")
	else:
		$AnimationPlayer.play("RESET")
	display_speed = float(score - score_displayed)/100 
	if display_speed < 1:
		display_speed = 1
	if score_factor >= 64:
		switch_music(2)
		rock.emit()
	elif score_factor >= 16:
		switch_music(1)
		end_rock.emit()
	else:
		switch_music(0)
		end_rock.emit()

		
func switch_music(music_level: int):
	if music_cur.stream == musics[music_level].stream or mus_tween:
		return
	mus_tween = create_tween()
	var new_mus:AudioStreamPlayer = musics[music_level]
	new_mus.play(music_cur.get_playback_position())
	mus_tween.tween_property(new_mus, "volume_db", 0, 1)
	await mus_tween.finished
	music_cur.stream = musics[music_level].stream
	music_cur.play(new_mus.get_playback_position())
	new_mus.playing = false
	new_mus.volume_db = -10.0
	mus_tween.kill()
	mus_tween = null
	pass
	
func update_score(value: int):
	score += value * score_factor
	progress_bar.value += 1
	var tween_duration = (score - score_displayed) / (SCORE_INCREMENT_SPEED * display_speed)
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_parallel()
	tween.tween_property(self, "score_displayed", score, tween_duration)
	tween.tween_method(func(_unused): score_UI.text = (
		"[center]"+ "0".repeat(SCOREDIGIT - len(str(score))) + "%d[/center]"%round(score_displayed)), 0, 0, tween_duration)

func update_progress_bar(player_curr_health: int):
	progress_bar.value += 1 - (10-player_curr_health) * 0.05
	pass
		
func update_energy(trivalue: float, squvalue: float, penvalue: float):
	if ene_tween:
		ene_tween.kill()
		ene_tween = null
	ene_tween = create_tween()
	ene_tween.set_parallel()
	ene_tween.tween_property(trigene_UI, "value", trivalue, 0.1)
	ene_tween.tween_property(squene_UI, "value", squvalue, 0.1)
	ene_tween.tween_property(penene_UI, "value", penvalue, 0.1)
	
		
	
func get_score():
	return score

func _on_score_factor_decrease_timeout() -> void:
	progress_bar.value -= progress_bar.max_value/10
		
func _on_progress_bar_value_changed(value: float) -> void:
	if progress_bar.value == progress_bar.max_value:
		update_factor()
	elif progress_bar.value == 0.0:
		reset_factor()


func update_factor():
	if score_factor == 128:
		return
	score_factor = score_factor*2
	progress_bar.max_value = progress_bar.max_value*2
	progress_bar.value = progress_bar.max_value * 0.3
	score_factor_UI.text = ("[center]X%d[/center]" %score_factor)


func reset_factor():
	# when getting hit directly the progress bar will NOT be reset
	# this is an intended behaviour
	if score_factor == 1:
		return
	score_factor = score_factor/2
	progress_bar.value = (progress_bar.max_value/2) * 0.8
	progress_bar.max_value = progress_bar.max_value/2
	score_factor_UI.text = ("[center]X%d[/center]" %score_factor)


func _on_restart_pressed() -> void:
	score = 0
	score_UI.text = "[center]"+ "0".repeat(SCOREDIGIT) + "[/center]"
	score_factor = 1
	start_game()
	spawn_player.emit()
