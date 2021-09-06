extends KinematicBody

var speed = 10
var accel = 10
var gravity = .3
var jump = 6

var mouse_sens = 0.03

var direction = Vector3()
var velocity = Vector3()
var fall = Vector3() 

onready var head = $Head

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sens))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sens)) 
		head.rotation.x = clamp(head.rotation.x, deg2rad(-90), deg2rad(90))
		
func _physics_process(delta):
	
	direction = Vector3()
	
	if not is_on_floor():
		fall.y -= gravity
		accel = 1
	else:
		accel = 5
	
	if Input.is_action_pressed("front"):
		direction -= transform.basis.z
		
	elif Input.is_action_pressed("back"):
		direction += transform.basis.z
		
	if Input.is_action_pressed("left"):
		direction -= transform.basis.x
		
	elif Input.is_action_pressed("right"):
		direction += transform.basis.x
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		fall.y = jump
		
	direction = direction.normalized()
	velocity = velocity.linear_interpolate(direction * speed, accel * delta) 
	velocity = move_and_slide(velocity, Vector3.UP) 
	move_and_slide(fall, Vector3.UP)
