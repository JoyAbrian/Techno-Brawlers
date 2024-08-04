extends Node2D

func _on_play_button_button_down():
	get_tree().change_scene_to_file("res://Scenes/game_scene.tscn")

func _on_quit_button_button_down():	
	get_tree().quit()
