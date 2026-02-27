class_name GameBg
extends Node2D

var bgBounds : Vector2

@export var rect : ColorRect
@export var cam : Cam
@export var zoomScaler : Node2D
@export var starHolder : Node2D
var stars : Array[Stars]

@export var bgDetailHolder : Node2D
@export var bgDetailPacked : PackedScene
@export var bgDetailCount : int
@export var bgDetailTex : Array[Texture2D]
var bgDetails : Array[BgDetail]


func _ready():
	var clampBoundsExtended=cam.clampBounds+cam.maxZoomBounds
	bgBounds=cam.layoutZoomBounds if cam.layoutZoomBounds>clampBoundsExtended else clampBoundsExtended
	for c : Stars in starHolder.get_children():
		stars.append(c)
	for s in stars:
		s.setup(bgBounds,cam.maxZoomBounds)
	
	for i in range(bgDetailCount):
		var cur : BgDetail = bgDetailPacked.instantiate()
		bgDetails.append(cur)
		bgDetailHolder.add_child(cur)
	for b in bgDetails:
		b.setup(bgBounds, cam.maxZoomBounds,bgDetailTex.pick_random())


func _process(delta):
	zoomScaler.scale=Vector2.ONE/cam.camera.zoom.x
	var parallaxT : Vector2 = cam.getPercentageInBounds()
	parallaxT-=Vector2.ONE*0.5
	parallaxT*=2

	for s in stars:
		s.parallaxUpdate(parallaxT)
	for b in bgDetails:
		b.parallaxUpdate(parallaxT)
