class_name Item
extends RigidBody2D
# Item prototype

# Base item stats
export(String) var item_name = null
export(bool) var key:bool = false
export(int) var phys_potency:int = 0
export(int) var mag_potency:int = 0
export(String) var affects = null
export(String, "Ranged", "Item") var equip_slot = null
export(int) var stack_size:int = 10
export(Texture) var icon_texture = ImageTexture.new()

# Projectile information
var direction = Vector2()
var speed = 100
var collisions
var thrower
var thrown = false

var signal_connect_dummy

var rng = RandomNumberGenerator.new()

onready var sprite = $Sprite

func _ready():
	if thrown:
		$GatherArea.visible = false
		mode = 0
	else:
		mode = 1
		rng.randomize()
		var rand_int = rng.randi_range(0,1)
		$Anim.play($Anim.get_animation_list()[rand_int])

	signal_connect_dummy = $GatherArea.connect("body_entered", self, "gather_item")
	signal_connect_dummy = $VisibilityNotifier2D.connect("screen_exited", self, "queue_free")

func _physics_process(_delta):
	if thrown:
		resolve_collisions()

func _integrate_forces(state):
	if thrown:
		state.angular_velocity = 15
		state.linear_velocity = direction * speed

func use(_actor):
	pass

func gather_item(body):
	if body is Entity:
		if body.inventory.add_item(duplicate()):
			queue_free()

func resolve_collisions():
	collisions = get_colliding_bodies()

	if collisions:
		var collider = collisions[0]

		if collider.has_method("hit"):
			collider.hit(thrower, phys_potency)

		queue_free()
