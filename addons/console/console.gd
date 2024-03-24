class_name Console

static func _static_init() -> void:
	connect_out(func(s): print(s))

static var console_out : Array = []
static func connect_out(delegate : Callable):
	console_out.append(delegate)

static func _parse_quotes(args : PackedStringArray) -> PackedStringArray:
	var new_args : PackedStringArray = []
	var parsing = false
	var working : String = ""
	for argv in args:
		var arg : String = argv
		if parsing:
			if arg.ends_with("\"") && !arg.ends_with("\\\""):
				parsing = false
				working += " "+arg.substr(0,arg.length()-1);
				new_args.append(working)
			else:
				working += " "+arg;
		else:
			if arg.is_empty():
				continue
			if arg.begins_with("\""):
				parsing = true
				working = arg.substr(1)
				if working.ends_with("\"") && !working.ends_with("\\\"") :
					parsing = false
					working = working.substr(0,working.length()-1);
					new_args.append(working)
			else:
				new_args.append(arg)
				
	return new_args

static func Log(text : String):
	var s = str(text)+ "\n"
	for i in console_out:
		var c : Callable = i
		c.call(s)

static func _parse_bool(text : String) -> bool:
	text = text.to_lower()
	return text == "t" || text == "true" || text == "1"

static func exec(line : String):
	var commands = line.split(";",false)
	for command in commands:
		var args = _parse_quotes(command.split(" ",true))
		
		if ConsoleVar.ConsoleVars.has(args[0]):
			var convar : ConsoleVar = ConsoleVar.ConsoleVars[args[0]];
			if args.size() == 1:
				var s = str(convar.data)+ "\n"
				for i in console_out:
					var c : Callable = i
					c.call(s)
				return
			if convar.type == ConsoleVar.Type.STRING:
				convar.data = args[1];
				for argv in range(2,args.size()):
					convar.data += " "+ args[argv]
			if convar.type == ConsoleVar.Type.FLOAT:
				convar.data = float(args[1]);
			if convar.type == ConsoleVar.Type.INT:
				convar.data = int(args[1]);
			if convar.type == ConsoleVar.Type.BOOL:
				convar.data = _parse_bool(args[1]);
			Log("%s: %s" % [convar.key, str(convar.data)])
		elif ConsoleCommands.commands.has(args[0]):
			ConsoleCommands.commands[args[0]].call(args)
		else:
			Log("Failed to find function or variable : %s in line %s" % [args[0],command])

