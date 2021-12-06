extends Node2D


var p1 = null
var p2 = null
var left = null
var right = null
var flag = false

func _ready():
	var PlayerOne = load("res://ScorpionRight.tscn")

#	var main_scene = get_tree().current_scene
	p1 = PlayerOne.instance()
	p1.player_number = 1
	p1.facing = "Right"
	p1.global_position = Vector2(170, 510)
	add_child(p1)

	var PlayerTwo = load("res://ScorpionLeft.tscn")
	p2 = PlayerTwo.instance()
	p2.player_number = 2
	p2.facing = "Left"
	p2.global_position = Vector2(854, 510)
	add_child(p2)
	left = p1
	right = p2

var PlayerOne = load("res://ScorpionRight.tscn")
var PlayerTwo = load("res://ScorpionLeft.tscn")

func is_hitting(player):
	if player.animation_player.get_current_animation() == "Hit-1" or player.animation_player.get_current_animation() == "Hit-3" or player.animation_player.get_current_animation() == "Hit-4" or player.animation_player.get_current_animation() == "Hit-5":
		return true
	return false


var finish_flag = false

func _physics_process(delta):
	get_node("Health_1").value = p1.health
	get_node("Health_2").value = p2.health
	if p1.health <= 0 or p2.health <= 0:
		if p1.health <= 0:
			wait_for_fatality(p1)
		else:
			wait_for_fatality(p2)
	
	if is_hitting(p1):
		if p1.facing == "Right":
			p1.global_position.x = p1.global_position.x - 2
		else:
			p1.global_position.x = p1.global_position.x + 2
	if is_hitting(p2):
		if p2.facing == "Right":
			p2.global_position.x = p2.global_position.x - 2
		else:
			p2.global_position.x = p2.global_position.x + 2		
		
	if not flag:
		if p1.get_position().x >  p2.get_position().x and (p1.is_on_floor() and p2.is_on_floor()):
			var p1_position = p1.get_position()
			var p2_position = p2.get_position()
			var p1_vel = p1.velocity
			var p2_vel = p2.velocity
			var p1_health = p1.health
			var p2_health = p2.health


			p1.queue_free()
			p2.queue_free()

			p1 = PlayerTwo.instance()
			p2 = PlayerOne.instance()

			p1.player_number = 1
			p2.player_number = 2

			p1.velocity = p1_vel
			p2.velocity = p2_vel

			p1.health = p1_health
			p2.health = p2_health


			p1.global_position = p1_position
			p2.global_position = p2_position
			add_child(p1)
			add_child(p2)
			flag = true
	else:
		if p2.get_position().x >  p1.get_position().x and (p1.is_on_floor() and p2.is_on_floor()):
			var p1_position = p1.get_position()
			var p2_position = p2.get_position()
			var p1_vel = p1.velocity
			var p2_vel = p2.velocity
			var p1_health = p1.health
			var p2_health = p2.health
			p1.queue_free()
			p2.queue_free()

			p1 = PlayerOne.instance()
			p2 = PlayerTwo.instance()

			p1.player_number = 1
			p2.player_number = 2

			p1.velocity = p1_vel
			p2.velocity = p2_vel

			p1.health = p1_health
			p2.health = p2_health

			p1.global_position = p1_position
			p2.global_position = p2_position
			add_child(p1)
			add_child(p2)
			flag = false


func wait_for_fatality(player):
	if not finish_flag:
		get_node("voices").play("Finish_him")
		finish_flag = true
	player.animation_player.play('Dizzy')
	pass
