extends PropagateReceiver

class_name ConsoleGUI

@export var base_panel : Panel;
@export var log : RichTextLabel;
@export var input : TextEdit;

@export var margin : int = 10

func _ready() -> void:
	assert(base_panel != null)
	#assert(log != null)
	assert(input != null)
	Global.console = self
	Console.connect_out(on_console_out)

func on_console_out(text: String):
	log.text+=text;

enum State {NONE,MOVING,RESIZE}
var state : State = State.NONE

var max_history : ConsoleVar = ConsoleVar.create("c_max_history",100);

var history : Array = [];
var dirty :bool =false
var history_idx : int = -1;

var tabdirty :bool = true
var tabindex : int = -1
var tabdata : PackedStringArray

func change_state(state : State):
	if state == self.state:
		return
	if self.state == State.MOVING:
		stop_moving()
	elif self.state == State.RESIZE:
		stop_resize()
	self.state = state
	if state == State.MOVING:
		start_moving()
	elif state == State.RESIZE:
		start_resize()

var move_offset : Vector2
var mouse_pos : Vector2
func start_moving():
	move_offset = mouse_pos - position
func moving():
	position = mouse_pos-move_offset
func stop_moving():
	pass
func start_resize():
	mouse_pos = base_panel.global_position+ base_panel.size
	move_offset = base_panel.global_position
	Input.warp_mouse(mouse_pos) # not supported on wayland but /shrug
func resize():
	base_panel.size =  mouse_pos- move_offset
	log.size.x = base_panel.size.x - 2*margin
	log.size.y = base_panel.size.y - 6*margin
	input.size.x = base_panel.size.x - 2*margin;
	input.position.y = base_panel.size.y - 4*margin
func stop_resize():
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_pos = event.position
		if state == State.MOVING:
			moving()
		elif state == State.RESIZE:
			resize()

func recv(event : InputEvent, s : Variant):
	if s == base_panel:
		if event is InputEventMouseButton:
			if event.pressed:
				if event.button_index == MOUSE_BUTTON_LEFT:
					change_state(State.MOVING)
					pass
				elif event.button_index == MOUSE_BUTTON_MIDDLE:
					change_state(State.RESIZE)
					pass
			else:
				change_state(State.NONE)
	if s == input:
		if event is InputEventKey:
			if event.keycode == KEY_ENTER:
				var line = input.text;
				line = line.replace("\n","")
				if line.is_empty():
					input.text = ""
					dirty = false;
					history_idx = -1
					accept_event()
					return
				Console.exec(line);
				history.append(line)
				if history.size() > max_history.data:
					history.remove_at(0)
				history_idx = -1
				dirty = false;
				input.clear()
				accept_event()
			elif event.keycode == KEY_UP && !dirty:
				if history_idx == -1:
					history_idx = history.size()-1
				if history_idx >1:
					history_idx-=1
				input.text = history[history_idx]
				input.set_caret_column(input.text.length())
			elif event.keycode == KEY_DOWN && !dirty:
				if history_idx == -1:
					return;
				if history_idx < history.size()-1:
					history_idx+=1;
					input.text = history[history_idx]
					input.set_caret_column(input.text.length())
				else:
					input.clear()
			elif event.keycode == KEY_TAB:
				if !event.is_pressed():
					return
				if tabdirty:
					tabdirty = false
					tabindex = -1
					tabdata.clear()
					for keyv in ConsoleVar.ConsoleVars:
						var key : String = keyv
						if key.begins_with(input.text):
							tabdata.append(key)
					for keyv in ConsoleCommands.commands:
						var key : String = keyv
						if key.begins_with(input.text):
							tabdata.append(key)
				if tabdata.size() == 0:
					accept_event()
					return
				tabindex = (tabindex+1) % tabdata.size()
				input.text = tabdata[tabindex]
				input.set_caret_column(input.text.length())
				accept_event()
			else:
				dirty = true
				tabdirty = true
