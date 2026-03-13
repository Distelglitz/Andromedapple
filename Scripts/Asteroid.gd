class_name Asteroid
extends Area2D

@export var density : float = 300
var radius : float
var grav : GravitySource
var level : Level
var mass : float
var shaker : Shaker
var shape : CircleShape2D

@export var spSolid : Sprite2D
@export var spPatternBack : Sprite2D
@export var spPatternFront : Sprite2D

@export var textures : Array[Texture2D]

func _enter_tree():
	var colShape : CollisionShape2D = get_child(0)
	shape=colShape.shape
	shaker=get_child(1)
	collision_layer=4
	collision_mask=0

	var tex = textures.pick_random()
	spSolid.texture=tex
	spPatternBack.texture=tex
	spPatternFront.texture=tex

	spSolid.get_parent().rotation_degrees=randf()*360
	var uvOffset : Vector2 = Vector2(randf(),randf())*0.75
	Persistent.setupPattern(spPatternBack, Vector2(randf(),randf())*0.75)
	Persistent.setupPattern(spPatternFront, Vector2(randf(),randf())*0.75)
	spSolid.modulate=Persistent.c.rock(0)
	spPatternBack.modulate=Persistent.c.rock(1)
	spPatternFront.modulate=Persistent.c.rock(2)

func _ready():
	setRadius(scale.x*100)
	scale=Vector2.ONE


func setRadius(_radius):
	radius=_radius
	mass=density*pow(radius,2)
	if grav==null:
		grav=level.spawnGravitySource(self,Vector2.ZERO,mass,true)
	spSolid.scale=Vector2.ONE*(radius/100)
	spPatternBack.scale=Vector2.ONE*(radius/100)
	spPatternFront.scale=Vector2.ONE*(radius/100)
	shape.radius=radius

func hitByProj(proj : Projectile):
	shaker.Trigger()
