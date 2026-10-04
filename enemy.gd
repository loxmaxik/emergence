extends CharacterBody2D

@onready var player_node: CharacterBody2D = get_parent().get_node("Player")
@onready var right_ray: RayCast2D = $rightRay
@onready var left_ray: RayCast2D = $leftRay
@onready var left_wall_ray: RayCast2D = $leftwallray
@onready var right_wall_ray: RayCast2D = $rightwallray
@onready var timer: Timer = %Timer 
@export_range(-1,1) var dir: int=1
const SPEED = 50.0
var gravity = 15
var dead = false
var targeted=false
func _ready() -> void:
	if dir == 0:
		dir=1
func _physics_process(delta: float) -> void:
	if !dead:
		if dir == -1 and (!left_ray.is_colliding() or left_wall_ray.is_colliding()):
			dir = 1
		if dir == 1 and (!right_ray.is_colliding() or right_wall_ray.is_colliding()):
			dir = -1
			
		if Input.is_action_just_pressed("click") and targeted :
			dead=true
			
		velocity.x = SPEED * dir
	if Input.is_action_just_pressed("click") and targeted :
		velocity.x = int(global_position.x-player_node.global_position.x>0) *600
	if dead:
		velocity.x = move_toward(velocity.x, 0, 20)
	velocity.y += gravity
	move_and_slide()	



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body==player_node:
		if !dead and !player_node.immunity:
			get_tree().reload_current_scene()
			


func _on_gun_hitbox_body_entered(body: Node2D) -> void:
	if body==self:
		targeted=true # Replace with function body.


func _on_gun_hitbox_body_exited(body: Node2D) -> void:
	if body==self:
		targeted=false # Replace with function body.
