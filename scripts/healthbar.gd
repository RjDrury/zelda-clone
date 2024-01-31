extends ProgressBar

@onready var healthbar = $"."
@onready var attachedBody = $".."
func _process(_delta: float) -> void:
	if attachedBody:
		healthbar.value = attachedBody.health
