extends Control

var lineEdit1 : LineEdit
var lineEdit2 : LineEdit
var lineEdit3 : LineEdit
var lineEdit4 : LineEdit
var saveButton : TextureButton

func _ready():
	lineEdit1 = $LineEdit
	lineEdit2 = $LineEdit2
	lineEdit3 = $LineEdit3
	lineEdit4 = $LineEdit4
	saveButton = $saveButton

	_hide_line_edits()
	saveButton.connect("pressed", self, "_on_SaveButton_pressed")
	load_game()

func save_name(name1: String, name2: String, name3: String, name4: String) -> void:
	Global.nome = name1
	Global.nome2 = name2
	Global.nome3 = name3
	Global.nome4 = name4
	print("Nomes salvos: ", name1, name2, name3, name4)
	Global.salvar_jogo()
	get_tree().change_scene("res://cena/Inicio.tscn")

func load_game() -> void:
	Global.carregar_jogo()
	if Global.recorde != 0:
		print("Arquivo carregado com sucesso")
	else:
		print("Nenhum arquivo encontrado. Iniciando novo jogo.")

func _on_SaveButton_pressed():
	var emptyFields = false

	var lineEdits = [lineEdit1, lineEdit2, lineEdit3, lineEdit4]

	for lineEdit in lineEdits:
		var isVisible = lineEdit.visible
		var text = lineEdit.text.strip_edges()

		if isVisible && text.empty():
			lineEdit.placeholder_text = "Campo Obrigatório"
			lineEdit.add_color_override("font_color", Color.red)
			emptyFields = true
		else:
			lineEdit.placeholder_text = "Nome e Sobrenome"
			lineEdit.add_color_override("font_color", Color.white)

	if emptyFields:
		print("Preencha todos os campos obrigatórios!")
	else:
		var names = []
		for lineEdit in lineEdits:
			names.append(lineEdit.text.strip_edges())
		save_name(names[0], names[1], names[2], names[3])

	yield(get_tree().create_timer(1.5), "timeout")
	for lineEdit in lineEdits:
		lineEdit.placeholder_text = "Nome e Sobrenome"
		lineEdit.add_color_override("font_color", Color.white)

func _hide_line_edits() -> void:
	lineEdit1.hide()
	lineEdit2.hide()
	lineEdit3.hide()
	lineEdit4.hide()

func _on_qntdp_item_selected(index):
	_hide_line_edits()
	for i in range(index + 2):
		match i:
			0: lineEdit1.show()
			1: lineEdit2.show()
			2: lineEdit3.show()
			3: lineEdit4.show()
