extends Sprite

onready var mat := material.duplicate() as ShaderMaterial
onready var tween := $Tween as Tween


func _ready() -> void:
	material = mat


func start() -> void:
	tween.interpolate_property(
		self,
		"transform",
		self.transform,
		Transform2D.IDENTITY.scaled(Vector2.ONE * .5),
		.5,
		Tween.TRANS_CUBIC,
		Tween.EASE_OUT
	)
	tween.interpolate_method(self, "_erase", 1.0, .5, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_all_completed")
	queue_free()


func _erase(progress: float) -> void:
	mat.set_shader_param("progress", progress)
