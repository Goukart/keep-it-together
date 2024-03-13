extends Control

class_name UI

@onready var pauseMenu = $PauseMenu
@onready var menu = $"."

func _ready():
	pauseMenu.hide()
	menu.hide()


func _process(delta):
	if Input.is_action_just_pressed("menu"):
		pauseMenu.visible = !pauseMenu.visible
		if pauseMenu.visible:
			menu.show()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			menu.hide()
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_resume_pressed():
	menu.hide()
	pauseMenu.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_quit_pressed():
	get_tree().quit()
