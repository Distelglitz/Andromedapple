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
@export var bgDetailPer1000000 : float
@export var bgDetailTex : Array[Texture2D]

var bgDetails : Array[BgDetail]


func _ready():
	var clampBoundsExtended=cam.clampBounds+cam.maxZoomBounds
	for c : Stars in starHolder.get_children():
		stars.append(c)
	for s in stars:
		s.setup(cam.maxZoomBounds, cam.clampBounds, cam.layoutZoomBounds)
	

	var boundsA = cam.maxZoomBounds+cam.maxZoomBounds*BgDetail.maxParallax+Cam.padding
	var boundsB = cam.layoutZoomBounds+Cam.padding
	var selectedBounds=boundsA if boundsA.x>boundsB.x else boundsB
	var selectedSurface=selectedBounds.x*selectedBounds.y
	var bgDetailCount = ceili((selectedSurface/1000000)*bgDetailPer1000000)
	for i in range(bgDetailCount):
		var cur : BgDetail = bgDetailPacked.instantiate()
		bgDetails.append(cur)
		bgDetailHolder.add_child(cur)
	for b in bgDetails:
		b.setup(selectedBounds, cam.maxZoomBounds, bgDetailTex.pick_random(), 0 if randf()>0.5 else 1)


func _process(delta):
	zoomScaler.scale=Vector2.ONE/cam.camera.zoom.x
	var parallaxT : Vector2 = cam.getPercentageInBounds()
	parallaxT-=Vector2.ONE*0.5
	parallaxT*=2

	for s in stars:
		s.parallaxUpdate(parallaxT)
	for b in bgDetails:
		b.parallaxUpdate(parallaxT)
