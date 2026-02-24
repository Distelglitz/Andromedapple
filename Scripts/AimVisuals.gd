class_name AimVisuals
extends Node2D

@export var lineInner : Line2D
@export var width : float
var settingsMod : float = 1.25
var endPoint : Vector2
var cam : Camera2D
@export var spTip : Sprite2D
@export var tipScaleMod : float
var animP : float = 0

func _ready():
	lineInner.modulate=Persistent.c.fruit()
	spTip.modulate=Persistent.c.fruit()
	lineInner.width=width

var destroying : bool = false
func destroy():
	destroying=true
	animP=1

func update(_endPoint : Vector2):
	var mod = settingsMod*MathS.EaseInSquare(MathS.Clamp01(animP))
	
	endPoint = _endPoint
	lineInner.set_point_position(1,endPoint)
	lineInner.width=width/cam.zoom.x*mod

	spTip.position=endPoint
	spTip.scale=Vector2.ONE*tipScaleMod/cam.zoom.x*mod
	spTip.rotation_degrees=MathS.VecToDeg(endPoint.normalized())+90

func _process(delta):
	if destroying:
		animP-=delta*10
		update(endPoint)
		if animP<=0:
			queue_free()
	else:
		animP+=delta*5
