extends Node

enum QuestionType { TEXT, IMAGE, VIDEO, AUDIO }

export(Resource) var desafio
export(Color) var cor_certa
export(Color) var cor_errada

var tween_running = false
var original_scale = Vector2(0.5, 0.5)
var enlarged_scale = Vector2(0.55, 0.55)

var buttons := []
var index := 0
var quiz_shuffle := []

var timer := 30

var button_locked = false


onready var question_texts := $question_info/txt_question
onready var question_image := $question_info/image_holder/question_image
onready var question_video := $question_info/image_holder/question_video
onready var question_audio := $question_info/image_holder/question_audio

func _ready():
	Global.gameState = true
	$CHECK.focus_mode = Control.FOCUS_NONE
	$NCHECK.focus_mode = Control.FOCUS_NONE
	$men.focus_mode = Control.FOCUS_NONE
	for _button in $question_holder.get_children():
		buttons.append(_button)
		_button.focus_mode = Button.FOCUS_NONE
		

	quiz_shuffle = randomize_array(desafio.bd)
	#quiz_shuffle.resize(1) 
	$txt_qntd.text = str(index, "/", desafio.bd.size())
	load_quiz()

func load_quiz() -> void:
	if index >= desafio.bd.size():
		return
	
	var card = quiz_shuffle[index]
	
	question_texts.text = str(card.question_info)
	
	#respostas randomizadas
	var options = randomize_array(card.options)
	
	#botões
	for i in buttons.size():
		var button = buttons[i]
		button.text = ""  # remove o texto do botão
		var label = button.get_node("Label")  # obtém o nó do Label dentro do Button
		label.text = str(options[i])  # define o texto do Label como a opção de resposta
		button.connect("pressed",self, "buttons_answer", [button])
	
	match card.type:
		QuestionType.TEXT:
			$question_info/image_holder.hide()
			
		QuestionType.IMAGE:
			$question_info/image_holder.show()
			question_image.texture = card.question_image
			
		QuestionType.VIDEO:
			$question_info/image_holder.show()
			question_video.stream = card.question_video
			question_video.play()
		
		QuestionType.AUDIO:
			$question_info/image_holder.show()
			question_audio.stream = card.question_audio
			question_audio.play()
	

func buttons_answer(button):
	if button_locked:
		return

	button_locked = true

	var selected_option = button.get_node("Label").text  # Obtém a opção selecionada pelo usuário

	if desafio.bd[index].correct == selected_option:  # Verifica se a resposta selecionada está correta
		button.modulate = cor_certa
		Global.correct += 1
		Global.pontos += 1
		$valor.text = str(int($valor.text) + 1)
		if Global.pontos > Global.recorde:
			Global.recorde = Global.pontos
			Global.salvar_jogo()
		$audio_correto.play()
	else: 
		button.modulate = cor_errada
		$audio_errado.play()

	$redondo.value = 0
	_next_question()

	
func _next_question():
	quiz_shuffle.remove(index)  # Remover o desafio atual da lista
	$txt_qntd.text = str(index + 1, "/", desafio.bd.size())
	question_audio.stop()
	question_video.stop()
	timer = 30

	yield(get_tree().create_timer(1.3), "timeout")
	for bt in buttons:
		bt.modulate = Color.white
		bt.disconnect("pressed", self, "buttons_answer")
		button_locked = false  # Desbloqueia o botão

	question_audio.stream = null
	question_video.stream = null

	index += 1
	load_quiz()
	

func randomize_array(array : Array) -> Array:
	randomize()
	var array_temp := array
	array_temp.shuffle()
	return array_temp

func _on_timer_timeout():
	var secs = fmod(timer, 60)
	var time_passed = "%02d" % [secs]
	$txt_timer.text = time_passed
	$redondo.value += 1
	timer -= 1
	
	if timer < 0:
		$redondo.value = 0
		quiz_shuffle.remove(index)
		get_tree().change_scene("res://cena/Inicio.tscn")
	
	
func _on_btn_menu_pressed():
	Global.correct = 0
	Global.pontos = 0
	Global.recorde = 0
	get_tree().change_scene("res://cena/Menu.tscn")

func _on_FEZ_pressed():
	quiz_shuffle.remove(index)
	get_tree().change_scene("res://cena/Inicio.tscn")


func _on_CHECK_pressed():
	
	Global.skip_turn = false
	print("False")
	
	$FundoAzul.hide()
	$question_holder.hide()
	$question_info.hide()
	$CHECK.hide()
	$NCHECK.hide()
	$Desafioc.show()
	$Desafioi.hide()
	
	yield(get_tree().create_timer(4), "timeout")
	quiz_shuffle.remove(index)
	get_tree().change_scene("res://cena/Inicio.tscn")


func _on_NCHECK_pressed():
	
	var card = quiz_shuffle[index]
	if card.cor == "vem":
		Global.skip_turn = true
		print("TRUE")
	
	$FundoAzul.hide()
	$question_holder.hide()
	$question_info.hide()
	$CHECK.hide()
	$NCHECK.hide()
	$Desafioc.hide()
	$Desafioi.show()
	
	yield(get_tree().create_timer(4), "timeout")
	quiz_shuffle.remove(index)
	get_tree().change_scene("res://cena/Inicio.tscn")


func _on_CHECK_mouse_entered():
	$tween.interpolate_property($CHECK, "rect_scale", original_scale, enlarged_scale, 0.25, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$tween.start()


func _on_CHECK_mouse_exited():
	$tween.interpolate_property($CHECK, "rect_scale", enlarged_scale, original_scale, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$tween.start()


func _on_NCHECK_mouse_entered():
	$tween.interpolate_property($NCHECK, "rect_scale", original_scale, enlarged_scale, 0.25, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$tween.start()


func _on_NCHECK_mouse_exited():
	$tween.interpolate_property($NCHECK, "rect_scale", enlarged_scale, original_scale, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$tween.start()
