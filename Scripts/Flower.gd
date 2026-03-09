class_name Flower
extends Node2D

@export var tog : SmoothToggle
@export var spMain : Sprite2D
@export var spStem : Sprite2D
@export var minScale : float = 0.6
@export var maxScale : float = 1.4

@export var maxHeight : float

var delay : float
var swayT : float
@export var swaySpeed : float
@export var swayMag : float
var swayDir : int

func setup(_delay : float, showStem : bool):
	delay=_delay
	spMain.scale*=lerp(minScale,maxScale,randf())
	spMain.flip_h=randf()>0.5
	spMain.flip_v=randf()>0.5
	spStem.flip_h=randf()>0.5
	spStem.flip_v=randf()>0.5
	
	spMain.rotation_degrees=randf()*360
	spMain.modulate=Persistent.c.flower().lerp(Persistent.c.flowerDetail(),randf())
	spStem.modulate=Persistent.c.foliage()
	spStem.visible=showStem
	var height = maxHeight if showStem else 0
	var rand = randf()
	spMain.position+=Vector2.UP*height*pow(rand,0.5)
	spStem.position+=Vector2.UP*height*pow(rand,0.5)
	swayT=randf()
	swayDir=1 if randf()>0.5 else -1

func _ready():
	get_tree().create_timer(delay).timeout.connect(onTimeout)

func _process(delta: float):
	swayT+=delta
	tog.rotation_degrees=sin(swayT*swaySpeed)*swayMag*swayDir

func onTimeout():
	tog.TriggerOn()
