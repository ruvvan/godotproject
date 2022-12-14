class_name Projectile
extends RigidBody2D

var signal_connect_dummy
onready var sprite = $Sprite
var direction = Vector2()
var speed = 100
var collisions
var item_ref
var thrower

func _ready():
	signal_connect_dummy = $VisibilityNotifier2D.connect("screen_exited", self, "kill")

func _physics_process(_delta):
	resolve_collisions()

func _integrate_forces(state):
	state.angular_velocity = 15
	state.linear_velocity = direction * speed
	
func kill():
	queue_free()

func resolve_collisions():
	collisions = get_colliding_bodies()

	if collisions:
		var collider = collisions[0]

		if collider.has_method("hit"):
			collider.hit(thrower, item_ref.phys_potency)

		kill()
