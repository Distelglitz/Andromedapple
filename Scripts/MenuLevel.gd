class_name MenuLevel
extends Control

@export var layout : PackedScene
@export var unlocks : Array[MenuLevel]
var cord : Vector2i
var menu : Menu
enum LevelState{Disabled,Unlocked,Cleared}
var levelState : LevelState

var center : Node2D
var smScale : SmoothScale
var smMod : SmoothModulate
var sp : MenuColorSprite

var rotSpeed : float
const maxRotSpeed : float = 300
const rotDecel : float = 700

var selected : bool
var shaker : Shaker

func activate(_menu : Menu,_cord : Vector2i, _cleared : bool):
	modulate.a = 1
	sp.modulate.a=1
	if _cleared:
		levelState=LevelState.Cleared
		sp.idx=0
		sp.main=true
		sp.update()
	else:
		levelState=LevelState.Unlocked
		sp.idx=6
		sp.main=false
		sp.update()
	mouse_filter=Control.MOUSE_FILTER_STOP
	menu=_menu
	cord=_cord
	sp.texture = load("res://Sprites/Tex_LevelIcon_Cleared.png") if _cleared else load("res://Sprites/Tex_LevelIcon_Uncleared.png")
	MathS.SpriteFlipRand(sp)
	sp.rotation_degrees = randf()*360

func _process(delta):
	if not selected and rotSpeed != 0:
		rotSpeed -= sign(rotSpeed) * rotDecel * delta
		if abs(rotSpeed) <= 1:
			rotSpeed = 0

	sp.rotation_degrees += rotSpeed * delta

func _enter_tree():
	center = get_child(0)
	smScale=center.get_child(0)
	smMod=smScale.get_child(0)
	shaker=smMod.get_child(0)
	sp=shaker.get_child(0)
	
	center.position=size*0.5
	modulate.a=0
	levelState=LevelState.Disabled
	mouse_filter=Control.MOUSE_FILTER_IGNORE
	mouse_entered.connect(onMouseEntered)
	mouse_exited.connect(onMouseExited)
func onMouseEntered():
	menu.onMouseEntered(self)
	smMod.TriggerToA()
	smScale.TriggerToA()
	selected = true
	rotSpeed = maxRotSpeed * (-1 if randf() > 0.5 else 1)
func onMouseExited():
	menu.onMouseExited(self)
	smMod.TriggerToB()
	smScale.TriggerToB()
	selected = false

func getPos():
	return center.global_position

func getWorld():
	var result : MenuWorld = get_parent()
	return result

func onPressed():
	rotSpeed = 0
	shaker.Trigger(20)
