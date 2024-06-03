extends Node2D
class_name ParentLevel
#var sword:PackedScene = preload("res://Scenes/Weapons/test_sword.tscn")
#signal sword_back
@onready var http_request = $GameOver/ColorRect/Button/HTTPRequest
var url = "172.167.157.237:8080/puntuacion/save"
func _ready():
	#displays timer and wave on the in_game_ui
	$InGameUi/InGameUi/MarginContainer/VBoxContainer/Timer.text= str($Enemies/EnemySpawner.total_time)
	$InGameUi/InGameUi/MarginContainer/VBoxContainer/HBoxContainer/WaveNumber.text= str($Enemies/EnemySpawner.wave)
	$GameOver/ColorRect/Button.text = tr("send_score")
	$GameOver/ColorRect/Button2.text = tr("back_to_menu")

func _on_pause_menu_pause(visible2):
	#Shows the canvasLayer that contains the pause menu
	$CanvasLayer.visible = visible2
	$CanvasLayer/ColorRect2/PauseMenu/Menu/Start.grab_focus()


#func _on_knight_attack(delta, direction, current_position, rotationdeg):
	#if get_tree().get_nodes_in_group("Weapons").size() ==1:
		#var new_weapon = sword.instantiate()
		#new_weapon.global_position = current_position
		#new_weapon.rotation_degrees = rotationdeg
		#self.add_child(new_weapon)
		#new_weapon.get_child(3).attacka(delta, direction)


func _on_enemy_spawner_wave_ended():
	get_tree().get_first_node_in_group("player").position = Vector2.ZERO
	#Shows the upgradeMenu canvasLayer and hides the timer from the in_Game_ui
	$UpgradeMenu.visible = !$UpgradeMenu.visible
	Globals.upgrading = $UpgradeMenu.visible
	$InGameUi/InGameUi/MarginContainer/VBoxContainer/Timer.visible = !$InGameUi/InGameUi/MarginContainer/VBoxContainer/Timer.visible
	$InGameUi/InGameUi/MarginContainer2/VBoxContainer/HBoxContainer.visible = false#!$InGameUi/InGameUi/MarginContainer2/VBoxContainer/HBoxContainer.visible
	$InGameUi/InGameUi/MarginContainer2/VBoxContainer/HBoxContainer.visible = false#!$InGameUi/InGameUi/MarginContainer2/VBoxContainer/HBoxContainer.visible
	$UpgradeMenu/UpgradeMenu/ContinueMargin/Continue.grab_focus()
	#Deletes all remaining enemies, projectiles and loot from the past wave
	for i in $Enemies/EnemySpawner/enemies.get_children():
		i.queue_free()
	for i in $Loot.get_children():
		i.queue_free()
	for i in $Projectiles.get_children():
		i.queue_free()
	get_tree().paused = $UpgradeMenu.visible
	#Changes the wave number
	$InGameUi/InGameUi/MarginContainer/VBoxContainer/HBoxContainer/WaveNumber.text= str($Enemies/EnemySpawner.wave)



#Unpauses and ui time to the total time and the starting time to 1
func _on_upgrade_menu_resume():
	$UpgradeMenu.visible = !$UpgradeMenu.visible
	Globals.upgrading = $UpgradeMenu.visible
	$InGameUi/InGameUi/MarginContainer/VBoxContainer/Timer.visible = !$InGameUi/InGameUi/MarginContainer/VBoxContainer/Timer.visible
	get_tree().paused = $UpgradeMenu.visible
	$InGameUi/InGameUi/MarginContainer/VBoxContainer/Timer.text= str($Enemies/EnemySpawner.total_time)
	$Enemies/EnemySpawner.time = 1
	$InGameUi/InGameUi/MarginContainer2/VBoxContainer/HBoxContainer.visible = true#!$InGameUi/InGameUi/MarginContainer2/VBoxContainer/HBoxContainer.visible
	$InGameUi/InGameUi/MarginContainer2/VBoxContainer/HBoxContainer.visible = true#!$InGameUi/InGameUi/MarginContainer2/VBoxContainer/HBoxContainer.visible
	$InGameUi/InGameUi/MarginContainer2/VBoxContainer/HBoxContainer/GoldLabel.text = str(Globals.player_gold)


func _on_game_over_visibility_changed():
	$GameOver/ColorRect/Button.grab_focus()


func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://Scenes/Ui/main_menu.tscn")


func _on_button_pressed():
	var headers = ["Content-Type: application/json"]
	var data = {
		'jugador': OS.get_environment('USERNAME'),
		'puntos': Globals.player_points
	}
	var json = JSON.stringify(data)
	print(data)
	print(json)
	http_request.request("http://172.167.157.237:8080/puntuacion/save",headers,HTTPClient.METHOD_POST,json)
	print("sent")



func _on_http_request_request_completed(result, response_code, headers, body):
	if response_code == 200:
		$GameOver/ColorRect/Label2.text = "ok_response"
		$GameOver/ColorRect/Label2.text = tr("ok_response")
	else:
		$GameOver/ColorRect/Label2.text = "bad_response"
		$GameOver/ColorRect/Label2.text = tr("bad_response")

	 #var json = JSON.parse_string(body.get_string_from_utf8)
