class_name Reflector
extends Node2D

@export var area : Area2D
var shape : RectangleShape2D
@export var line : Line2D
@export var tip0 : Sprite2D
@export var tip1 : Sprite2D
var cd : float

@export var dur : float
@export var animEase : MathS.EasingMethod
@export var squash : SquashAnchor
var animT : float

func _enter_tree():
	shape=area.get_child(0).shape
	var scaleSaved : Vector2 = scale
	scale=Vector2.ONE
	line.set_point_position(0,Vector2(-500*scaleSaved.x,0))
	line.set_point_position(1,Vector2(500*scaleSaved.x,0))
	tip0.position=Vector2(-500*scaleSaved.x,0)
	tip1.position=Vector2(500*scaleSaved.x,0)
	shape.size.x=scaleSaved.x*1000
	area.body_entered.connect(onBodyEntered)
	
	colors(1)
	animT=dur
	MathS.SpriteFlipRand(tip0)
	MathS.SpriteFlipRand(tip1)


func _physics_process(delta):
	cd=max(0,cd-delta)

func _process(delta):
	if animT >= dur:
		return
	animT+=delta
	var p : float = MathS.Ease(animT/dur, animEase)
	colors(p)
	tip0.rotation_degrees=p*360
	tip1.rotation_degrees=p*360

func onBodyEntered(other : Node2D):
	if cd>0:
		return
	if not other is Projectile:
		return
	var p : Projectile = other
	p.linear_velocity=p.linear_velocity.reflect(MathS.DegToVec(rotation_degrees-90))
	p.resetFreeze()
	p.boost()
	cd=0.1

	squash.TriggerSquash(SquashAnchor.Small)
	animT = 0

func colors(p : float):
	var c : Color = Persistent.c.fruitDetail().lerp(Persistent.c.fruit(), MathS.Clamp01(p))
	tip0.modulate = c
	tip1.modulate = c
	line.modulate = c
