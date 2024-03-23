extends Control

@export var reciever : PropagateReceiver
func _ready() -> void:
	assert(reciever != null)
	
func _gui_input(event: InputEvent) -> void:
	reciever.recv(event,self);

