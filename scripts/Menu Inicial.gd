extends Control

var popup_instance 


func _ready():
	pass

func _on_start_pressed():
	$clique.play()
	yield(get_tree().create_timer(0.3), "timeout")
	get_tree().change_scene("res://cena/Inicio.tscn")

