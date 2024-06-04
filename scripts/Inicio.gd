extends Control

var popup_instance
var tween_running = false
var original_scale = Vector2(0.5, 0.5)
var enlarged_scale = Vector2(0.53, 0.53)
var popup_open = false

func _ready():
	$gop.focus_mode = Control.FOCUS_NONE
	$gameover.focus_mode = Control.FOCUS_NONE
	$campeao.focus_mode = Control.FOCUS_NONE

	# Define o estado inicial de input dos botões com base na variável popup_open
	set_button_input_state(not popup_open)

func _on_gop_pressed():
	if not tween_running and not popup_open:  # Verifica se nenhum popup está aberto
		$clique.play()
		yield(get_tree().create_timer(0.3), "timeout")
		popup_instance = preload("res://cena/level_game.tscn").instance()
		add_child(popup_instance)
		popup_open = true
		set_button_input_state(false)
		
func _on_popup_closed():
	popup_open = false
	set_button_input_state(true)

func _on_gopi_mouse_entered():
	$tween.interpolate_property($gop/gopi, "rect_scale", original_scale, enlarged_scale, 0.25, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$tween.start()

func _on_gopi_mouse_exited():
	$tween.interpolate_property($gop/gopi, "rect_scale", enlarged_scale, original_scale, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$tween.start()


func _on_tween_tween_completed(object, key):
	tween_running = false

func set_button_input_state(enabled):
	$gop.set_process_input(enabled)

func _on_campeao_pressed():
	get_tree().change_scene("res://cena/Campeao.tscn")


func _on_gameover_pressed():
	get_tree().change_scene("res://cena/GameOver.tscn")
