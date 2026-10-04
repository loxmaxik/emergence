extends CharacterBody2D

@export var SPEED = 200
const JUMP_VELOCITY = -400.0
@onready var timer: Timer = %Timer 
@onready var label: Label = %Label 
@onready var enemy: CharacterBody2D = get_parent().get_node("Enemy")

var gun=true
var immunity=false


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if !gun:
		label.text="%.2f" % timer.time_left
	
	
	

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = move_toward(velocity.x, direction *SPEED, 20)
	else:
		velocity.x = move_toward(velocity.x, 0, 20)

	if Input.is_action_just_pressed("click") and timer.is_stopped():
		self.velocity += self.global_position.direction_to(get_global_mouse_position()) * -400
		gun=false
		label.visible=true
		timer.start()
		
	move_and_slide()


func _on_timer_timeout() -> void:
	gun=true
	label.visible=false
	pass # Replace with function body.


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body==self:
		self.velocity.y= self.velocity.y * -1.3 +70 
		immunity=true


func _on_area_2d_2_body_exited(body: Node2D) -> void:
	if body==self:
		immunity=false
