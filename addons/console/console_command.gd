class_name ConsoleCommands

static func create(key: String,desc : String,delegate : Callable) -> bool:
	if commands.has(key):
		return false
	commands[key] = delegate
	descriptions[key] = desc;
	return true
	
static var commands : Dictionary = {}
static var descriptions : Dictionary = {}

#default commands

static func _static_init() -> void:
	create("list","List all Console variables",func( args : PackedStringArray): 
		var s : String = ""
		var count : int = 0
		for key in ConsoleVar.ConsoleVars:
			var v : ConsoleVar = ConsoleVar.ConsoleVars[key];
			s += key+": "+str(v.data)+"\n"
			count+=1
		s+= "Count: "+str(count)
		Console.Log(s)
	)
	create("help", "List all Console Commands",func( args : PackedStringArray): 
		var s : String = ""
		var count : int = 0
		for key in descriptions:
			
			s += key+ ": "+descriptions[key]+"\n"
			count+=1
		s+= "Count: "+str(count)
		Console.Log(s)
	)
	create("write","save variables to file, file = convars.txt",func( args : PackedStringArray):
		var filename :String = "convars.txt"
		if args.size() == 2:
			filename = args[1];
		var f = FileAccess.open("user://"+filename,FileAccess.WRITE)
		for key in ConsoleVar.ConsoleVars:
			var convar :ConsoleVar = ConsoleVar.ConsoleVars[key];
			f.store_string("%s %s" % [convar.key,str(convar.data)])
		f.close()
	)
	create("default","reset all vars",func( args : PackedStringArray):
		for key in ConsoleVar.ConsoleVars:
			var v : ConsoleVar = ConsoleVar.ConsoleVars[key]
			v.data = v.default
	)
	create("exec","execute a file, file : String",func( args : PackedStringArray):
		if args.size() != 2:
			Console.Log("bad arguments, should be "+args[0]+" file")
		var filename = args[1];
		var f = FileAccess.open("user://"+ filename,FileAccess.READ)
		var s = f.get_as_text(true).split("\n",false);
		for l in s:
			Console.exec(l)
	)
