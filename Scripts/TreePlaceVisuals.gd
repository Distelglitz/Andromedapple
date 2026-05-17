class_name TreePlaceVisuals
extends Node2D

@export var point : Node2D
@export var sc : Node2D

func destroy():
	queue_free()

func update(dir : Vector2, radius : float):
	rotation_degrees=MathS.VecToDeg(dir)
	point.position=Vector2.RIGHT*radius

func _ready():
	modulate = Persistent.c.ui()


@export var approxSpeed : float
@export var maxSquash : float
@export var squashMod : float

var dirOld : Vector2
var dotOld : float
var diffApprox : float

func _process(delta: float):
	var dot : float = abs(transform.x.dot(dirOld))
	var diff : float = abs(dot - dotOld)
	diffApprox += (diff-diffApprox)*delta*approxSpeed
	sc.scale.x = 1 - clamp(diffApprox*squashMod, 0, maxSquash)
	sc.scale.y = 1 / sc.scale.x

	dirOld = transform.x
	dotOld = dot

func _physics_process(delta: float):
	pass
