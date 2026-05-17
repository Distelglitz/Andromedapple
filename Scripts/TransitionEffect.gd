extends Node2D

@export var rect : ColorRect
var mat : ShaderMaterial

func _enter_tree():
	mat = rect.material
	TransitionManager.EV_VisualsUpdate.connect(onVisualsUpdate)
func _ready():
	set_process(false)


func onVisualsUpdate(prog : float, modeIn : bool):
	var easeM : MathS.EasingMethod = MathS.EasingMethod.InSquare if modeIn else MathS.EasingMethod.InCubic
	mat.set_shader_parameter("cutoutMode", not modeIn)
	mat.set_shader_parameter("prog", MathS.Ease(prog,easeM))
	
	if modeIn and prog==1: # prevents flicker when changing from menu to game
		scale=Vector2.ONE*5000
	else:
		scale = Vector2.ONE / Persistent.currentCameraZoom
	position = Persistent.currentCameraPos
	if not modeIn and prog==1:
		visible = false
	else:
		visible = true
