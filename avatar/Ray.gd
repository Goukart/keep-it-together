extends RayCast3D

@onready var prompt = $Prompt

func _ready():
	add_exception(owner)

func _physics_process(_delta):
	prompt.text = ""
	if is_colliding():
		var object = get_collider()
		if object is Interactable:
			prompt.text = object.name
