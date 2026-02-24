class_name GameBg
extends Node2D

@export var rect : ColorRect
@export var cam : Cam
@export var zoomScaler : Node2D
@export var starHolder : Node2D
var stars : Array[Stars]

@export var parallax : float

func _ready():

	for c : Stars in starHolder.get_children():
		stars.append(c)
	for s in stars:
		s.setup(cam.maxZoomBounds,cam.clampBounds , cam.layoutZoomBounds)

func _process(delta):
	zoomScaler.scale=Vector2.ONE/cam.camera.zoom.x
	var tInBounds : Vector2 = cam.getPercentageInBounds()
	for s in stars:
		s.parallaxUpdate(tInBounds)
