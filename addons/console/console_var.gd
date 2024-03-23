class_name ConsoleVar
extends Object

enum Type {STRING, FLOAT, INT, BOOL}

var key : String
var data : Variant
var default : Variant
var type : Type

func _verify_type():
	if data is String:
		type = Type.STRING
	elif data is float:
		type = Type.FLOAT
	elif data is int:
		type = Type.INT
	elif data is bool:
		type = Type.BOOL
	else:
		printerr("ConsoleVar %s has bad key type %s" % [key,typeof(data)])

static func create(key:String,default_value : Variant = null) -> ConsoleVar:
	if ConsoleVars.has(key):
		return ConsoleVars[key]
	var ret :ConsoleVar = new()
	ret.key = key
	ret.data = default_value
	ret.default = default_value
	ret._verify_type()
	ConsoleVars[key] = ret;
	return ret;
	
static var ConsoleVars : Dictionary
