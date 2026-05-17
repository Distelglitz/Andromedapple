class_name MenuColorSprite
extends Sprite2D

@export var selfMod : bool
@export var main : bool
@export var idx : int

func _enter_tree():
	add_to_group("Color")
func _ready():
	t = 100
	var target = get_parent() if targetParent else self
	startCol = target.self_modulate if selfMod else target.modulate
	targetCol = getTargetCol()
	setCol(1)

var startCol : Color
var targetCol : Color
var t
@export var targetParent : bool

func update():
	set_process(true)
	targetCol = getTargetCol()

	var target = get_parent() if targetParent else self
	startCol = target.self_modulate if selfMod else target.modulate
	t=0

func _process(delta: float):
	t = min(delta+t, MenuColorDetector.duration)
	setCol(MathS.Ease(t / MenuColorDetector.duration, MenuColorDetector.easeM))
	if t == MenuColorDetector.duration:
		setCol(1)
		set_process(false)

func setCol(p : float):
	var target = get_parent() if targetParent else self
	var col : Color = lerp(startCol, targetCol, p)
	if selfMod:
		target.self_modulate = Color(col.r, col.g, col.b, self_modulate.a)
	else:
		target.modulate = Color(col.r, col.g, col.b, modulate.a)

func getTargetCol():
	if main :
		return Persistent.c.main[idx]
	else:
		return Persistent.c.secondary[idx]
