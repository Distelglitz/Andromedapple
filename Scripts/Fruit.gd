class_name Fruit
extends Node2D

@export var tog : SmoothToggle
@export var selectScale : SmoothScale
@export var togSpeedRange : Vector2
@export var rotPoint : Node2D
@export var spStem : Sprite2D
@export var spMain : Sprite2D
@export var spDetail : Sprite2D

@export var textures : Array[Texture2D]
@export var texturesDetail : Array[Texture2D]

var t : float
@export var sinMag : float
@export var sinSpeed : float

func _enter_tree():
	tog.speedIn=lerp(togSpeedRange.x,togSpeedRange.y,randf())
	setFruitState(FruitState.Normal)
	var idx = randi_range(0, textures.size()-1)
	spMain.texture=textures[idx]
	spDetail.texture=texturesDetail[idx]

	spStem.modulate=Persistent.c.fruitDetail()
	spMain.modulate=Persistent.c.fruit()
	spDetail.modulate=Persistent.c.fruitDetail()

	if randf()>0.5:
		rotPoint.get_child(0).scale*=Vector2(-1,1)
	t=randf()*100

func _process(delta):
	t+=delta
	rotPoint.rotation_degrees=sin(t*sinSpeed)*sinMag

#TODO not sure if this is needed
func setup():
	pass

func onFocusEntered():
	EV_enter.emit(self)
func onFocusExit():
	EV_exit.emit(self)
signal EV_enter
signal EV_exit

enum FruitState{Normal,Selected,Aiming}
var fruitVisualState : FruitState
func setFruitState(_newState : FruitState):
	fruitVisualState=_newState
	if fruitVisualState==FruitState.Normal:
		selectScale.TriggerToA()
	else:
		selectScale.TriggerToB()
	#spMain.modulate=Color(1,0,0,1) if fruitVisualState==FruitState.Aiming else Color(1,1,1,1)
