extends Node
signal stat_change
var player_pos : Vector2
var current_language:String
var player_gold: int
var player_points: int
#TODO estos valores deberían ser cargados del guardado o algo
var fullscreen:bool
var vsync:bool = true
var borderless:bool = true
var master_sound:int = 100
var music_sound:int = 100
var fx_sound:int = 100
var upgrading:bool = false
