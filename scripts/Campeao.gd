extends Control


func _ready():
	$Button.focus_mode = Control.FOCUS_NONE
	

func _on_Button_pressed():
	get_tree().change_scene("res://cena/Menu Inicial.tscn")
