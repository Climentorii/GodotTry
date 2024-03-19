extends CharacterBody3D

var run_speed = 1
var gravity = 10

func get_input():
	velocity.x = 0
	var right = Input.is_action_pressed('Right')
	var left = Input.is_action_pressed('Left')
	var up = Input.is_action_pressed('Up')
	var down = Input.is_action_pressed('Down')
	var back = Input.is_action_pressed('Back')
	var forward = Input.is_action_pressed('Forward')
	var stop = Input.is_action_pressed('Stop')
	if right:
		velocity.x += 2 * run_speed
	if left:
		velocity.x -= 2 * run_speed
	if up:
		velocity.y += 0.7 * run_speed
	if down:
		velocity.y -= 0.7 * run_speed
	if forward:
		velocity.z -= 0.7 * run_speed
	if back:
		velocity.z += 0.7 * run_speed
	if stop:
		velocity.x = 0
		velocity.y = 0
		velocity.z = 0

func _physics_process(delta):
	velocity.y -= gravity * delta
	get_input()
	move_and_slide()
