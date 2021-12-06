extends KinematicBody2D


var MAX_SPEED = 500
var ACCELERATION = 2000
var FRICTION = 60000
var JUMP_FORCE = 10000
var GRAVITY = 3000
var health = 100
var animation = "Stance-1"
var facing = "Right"

var velocity = Vector2.ZERO
var speed = Vector2.ZERO
var player_number = null
var animation_player = null
var timer = null
var hit_timer = null
var special_move_1 = ["down", "left", "punch-1"]
var sequence = []

var up = ""
var down = ""
var right = ""
var left = ""
var punch_1 = ""
var punch_2 = ""
var kick_1 = ""
var kick_2 = ""
var block = ""



func init():
	if player_number == 1:
		up = "Jump"
		down = "Sit"
		right = "Right"
		left = "Left"
		punch_1 = "Punch-1"
		punch_2 = "Punch-2"
		kick_1 = "Kick-1"
		kick_2 = "Kick-2"
		block = "Block"
	elif player_number == 2:
		up = "Jump-CH2"
		down = "Sit-CH2"
		right = "Right-CH2"
		left = "Left-CH2"
		punch_1 = "Punch-1-CH2"
		punch_2 = "Punch-2-CH2"
		kick_1 = "Kick-1-CH2"
		kick_2 = "Kick-2-CH2"
		block = "Block-CH2"

func _ready():
	timer = get_node("Timer")
	hit_timer = get_node("Hit-Time")
	animation_player = get_node("Animation")
	init()
	

func _physics_process(delta):	
	#print_metrics()
	set_jumping()
	set_speed()
	
	var velocity_y = velocity.y
	handle_input(delta)
	
	velocity = set_velocity(Vector2(velocity.x, velocity_y), delta)
	velocity = move_and_slide(velocity, Vector2.UP)


func apply_rules(delta):
	if is_on_floor():
		if not animation_player.is_playing():
			if is_hold(left) or is_hold(right):
				animation_player.play("Walk-1")
			else:
				animation_player.play("Stance-1")
		if check("Jump"):
			if not is_hold(right) and not is_hold(left):
				velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
				animation_player.stop()
				animation_player.play("Stance-1")
				print("stance")
			else:
				animation_player.stop()
				animation_player.play("Walk-1")
				print("Stance-1")
				velocity = velocity.move_toward(Vector2(speed.x, 0) * MAX_SPEED, ACCELERATION * delta)
		if check("Walk-1"):
			if not is_hold(right) and not is_hold(left):
				velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
				animation_player.stop()
				animation_player.play("Stance-1")
				print("stance")
			else:
				velocity = velocity.move_toward(Vector2(speed.x, 0) * MAX_SPEED, ACCELERATION * delta)
		if check("Sit"):
			if not is_hold(down):
				animation_player.stop()
				animation_player.play("Stance-1")
				print("stance")
		if check("Block-1") or check("Block-2"):
			if not is_hold(block):
				if is_hold(down):
					animation_player.stop()
					animation_player.play("Sit")
					print("stance")
				else:
					animation_player.stop()
					animation_player.play("Stance-1")
					print("stance")
		if check("Punch-1") or check("Punch-2") or check("Punch-3") or check("Punch-4") or check("Punch-5"):
			velocity.x = 0
		if check("Kick-1") or check("Kick-2") or check("Kick-3") or check("Kick-4") or check("Kick-5") or check("Kick-6"):
			velocity.x = 0
		if check("Punch-4") or check("Kick-3") or check("Kick-4"):
			animation_player.stop()
	else:
		if is_hold(right) or is_hold(left):
			velocity = velocity.move_toward(Vector2(speed.x, 0) * MAX_SPEED, ACCELERATION * delta)

func handle_input(delta):
	if sequence == special_move_1:
		print("GET OVER HERE...............")
#		$Spear.visible = true
#		get_node("Extera").play("Spear")
#		animation_player.stop()
		animation_player.play("Special-3")
	apply_rules(delta)
	if is_on_floor():
		if 	Input.is_action_pressed(up):
			sequence.append("up")
			animation_player.play("Jump")
			print("up")
		if Input.is_action_just_pressed(down):
			timer.stop()
			timer.set_wait_time(1)
			timer.start()
			sequence.append("down")
			if not check("Punch-1") and not check("Punch-2") and not check("Punch-3") and not check("Punch-4") and not check("Punch-5")  and not check("Kick-1")  and not check("Kick-2")  and not check("Kick-3")  and not check("Kick-4")  and not check("Kick-5")  and not check("Kick-6"):
				animation_player.play("Sit")
				print("down")
		if Input.is_action_just_pressed(right):
			if not check("Punch-1") and not check("Punch-2") and not check("Punch-3") and not check("Punch-4") and not check("Punch-5")  and not check("Kick-1")  and not check("Kick-2")  and not check("Kick-3")  and not check("Kick-4")  and not check("Kick-5")  and not check("Kick-6"):
				sequence.append("right")
				animation_player.play("Walk-1")
				print("right")
		if Input.is_action_just_pressed(left):
			if not check("Punch-1") and not check("Punch-2") and not check("Punch-3") and not check("Punch-4") and not check("Punch-5")  and not check("Kick-1")  and not check("Kick-2")  and not check("Kick-3")  and not check("Kick-4")  and not check("Kick-5")  and not check("Kick-6"):
				sequence.append("left")
				animation_player.play("Walk-1")
				print("left")
		if Input.is_action_just_pressed(block):
			sequence.append("block")
			velocity.x = 0
			if check("Sit"):
				animation_player.stop()
				animation_player.play("Block-2")
			else:
				animation_player.stop()
				animation_player.play("Block-1")
				print('block')
		if Input.is_action_just_pressed(punch_1):
			sequence.append("punch-1")
			if check("Stance-1") or check("Walk-1") or check("Sit"):
				velocity.x = 0
				if is_hold(down):
					animation_player.play("Punch-3")
				else:
					animation_player.play("Punch-1")
				print("Punch")
		if Input.is_action_just_pressed(punch_2):
			sequence.append("punch-2")
			if check("Stance-1") or check("Walk-1") or check("Sit"):
				velocity.x = 0
				if is_hold(down):
					animation_player.play("Punch-5")
				else:
					animation_player.play("Punch-2")
				print("Punch")
		if Input.is_action_just_pressed(kick_1):
			sequence.append("kick-1")
			if check("Stance-1") or check("Walk-1") or check("Sit"):
				velocity.x = 0
				if is_hold(down):
					animation_player.play("Kick-5")
				else:
					animation_player.play("Kick-1")
				print("Punch")
		if Input.is_action_just_pressed(kick_2):
			sequence.append("kick-2")			
			if check("Stance-1") or check("Walk-1") or check("Sit"):
				velocity.x = 0
				if is_hold(down):
					animation_player.play("Kick-2")
				else:
					animation_player.play("Kick-6")
				print("Punch")
	else:
		if Input.is_action_just_pressed(punch_1) or Input.is_action_just_pressed(punch_2):
			animation_player.play("Punch-4")
		if Input.is_action_just_pressed(kick_1):
			animation_player.play("Kick-3")
		if Input.is_action_just_pressed(kick_2):
			animation_player.play("Kick-4")


# ======================= SETTER ================
func set_jumping():
	if is_on_floor():
		if Input.is_action_pressed(up):
			velocity.y = -JUMP_FORCE

func set_speed():
	speed.x = int(Input.get_action_strength(right)) - int(Input.get_action_strength(left))
	speed.y = int(Input.get_action_strength(down)) - int(Input.get_action_strength(up))
	speed =  speed.normalized()

func apply_gravity(velocity_y, delta):
	return velocity_y + GRAVITY * delta

func set_velocity(velocity, delta):
	velocity.y = clamp(apply_gravity(velocity.y, delta), -1500, 500)
	velocity.x = 0 if is_hold(down) else velocity.x
	return velocity
# ======================= SETTER ================
# =====================CHECKER===================
func check(anim):
	if animation_player.get_current_animation() == anim:
		return true
	return false

func is_hold(key):
	return true if Input.get_action_strength(key) > 0 else false
# =====================CHECKER===================
# ==================MOVE-NOMOVE==================

func print_metrics():
	print("FPS: " + str(Performance.get_monitor(Performance.TIME_FPS)))
	print("RAM: " + str(Performance.get_monitor(Performance.MEMORY_STATIC/1024/1024)) + "MB")


func _on_Timer_timeout():
	print(sequence)
	sequence.clear()

var random_hit = RandomNumberGenerator.new()
var hits = ["Hit-1", "Hit-3", "Hit-4", "Hit-5"]


var time_flag = true
func _on_Hurtbox_area_entered(area):
	
	if time_flag:
		health -= 15
		random_hit.randomize()
		random_hit.randi_range(0, 3)
		if check("Sit"):
			animation_player.play("Hit-2")
		else:
			animation_player.play(hits[random_hit.randi_range(0, 3)])
			print("Player" + str(player_number) + "health: " + str(health))
			time_flag = false
			hit_timer.set_wait_time(2)
			hit_timer.start()
			$Blood.visible = true
			$Blood2.visible = true
			
			get_node("Extera").play("Blood")


func _on_HitTime_timeout():
	time_flag = true
	


func _on_Extera_animation_finished(anim_name):
	if anim_name == "Blood":
		$Blood.visible = false
		$Blood2.visible = false
#	if anim_name == "Spear":
#		$Spear.visible = false
