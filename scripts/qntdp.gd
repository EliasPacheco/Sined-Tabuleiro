extends OptionButton

func _ready():
	# Adicionar a opção "0" como uma opção invisível
	add_item("0", 0)
	

	# Adicionar as demais opções visíveis
	add_item("2")
	add_item("3")
	add_item("4")

	# Definir a opção inicial selecionada como "2"
	select(0) # O índice 1 representa a segunda opção "2"
	remove_item(0)
