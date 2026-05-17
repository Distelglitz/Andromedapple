class_name MenuColorDetector
extends Node2D

const duration : float = 0.5
const easeM : MathS.EasingMethod = MathS.EasingMethod.OutSquare

var oldColorScheme : ColorScheme
func _process(delta):
    if oldColorScheme != Persistent.c and oldColorScheme != null:
        get_tree().call_group("Color", "update")
    oldColorScheme = Persistent.c