# Source like console for Godot

## Usage

### Console
Console is a control that can be dragged into a scene.

it can be dragged in runtime by clicking on the panel and dragging it to the desired location.

it can be resized by middle click dragging the panel

### Variables
declare a variable of type `ConsoleVar` and call `ConsoleVar.create(key, default_value)`

```gd
var my_int = ConsoleVar.create("my_var", 0)
var my_float = ConsoleVar.create("my_float", 0.0)
var my_string = ConsoleVar.create("my_string", "Hello, World!")
var my_bool = ConsoleVar.create("my_bool", false)

# values can be accessed like this
print(my_int.data)
print(my_float.data)
print(my_string.data)
print(my_bool.data)
```

it can be used for enums as well, however it will only accept ints as values

```gd
enum MyEnum {ONE, TWO, THREE}
var my_enum = ConsoleVar.create("my_enum", ONE as int)

# values can be accessed like this
print(my_enum.data as MyEnum)
```

in the console you can access the variables by typing their key and the value you want to set them to or just the key to display its current value.
```
$ my_int 5
my_int: 5
$ my_int
5
$ my_float 3.14
my_float: 3.14
```
Strings can be set with or without quotes
```
my_string "Hello, Godot!"
my_string: Hello, Godot!
```

## Installation
1. Clone this repository or download the zip and extract it 
2. Copy the `addons` folder to your project folder
