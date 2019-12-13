import sys.io.File;
import haxe.ds.Option;

enum abstract OpCode(Int) to Int {
	var Add = 1;
	var Mult = 2;
	var Input = 3;
	var Output = 4;
	var JumpTrue = 5;
	var JumpFalse = 6;
	var LessThan = 7;
	var Equals = 8;
	var AdjusteRelativeBase = 9;
	var Halt = 99;
}

enum OpMode {
	Position;
	Immediate;
	Relative;
}

class IntCodeVM {
	public static function parseProgram(data:String):Array<Float> {
		return data.split(",").map(Std.parseFloat);
	}

	public static function loadProgram(path:String):Array<Float> {
		return parseProgram(File.getContent(path));
	}

	public static function runProgram(path:String):IntCodeVM {
		return new IntCodeVM(loadProgram(path), []);
	}

	public static function validate() {
		var values = [
			days.Day02.part1(), days.Day02.part2(),
			days.Day05.part1(), days.Day05.part2(),
			days.Day07.part1(), days.Day07.part2(),
			days.Day09.part1(), days.Day09.part2(),
		];

		var answers = [
			   3654868,     7014,
			  15097178,  1558663,
			    225056, 14260332,
			2890527621,    66772,
		];

		for (i in 0...values.length) {
			if (values[i] != answers[i]) {
				throw "IntCodeVM does't pass validation test";
			}
		}
	}

	public var memory:Array<Float>;

	var inputs:Array<Float>;
	var pointer:Int;
	var base:Int;
	var halted:Bool;

	public function new(memory:Array<Float>, inputs:Array<Float>) {
		this.memory = memory.copy();
		this.inputs = inputs;
		this.pointer = 0;
		this.base = 0;
		this.halted = false;
	}

	public function input(i:Float) {
		inputs.push(i);
	}

	public function allOutput():Array<Float> {
		var o = [];

		while (true) {
			switch (output()) {
				case Some(v):
					o.push(v);
				case None:
					return o;
			}
		}
	}

	public function output():Option<Float> {
		if (halted) {
			return None;
		}

		while (true) {
			var cell = parseOpCode(memory[pointer++]);
			switch (cell.opcode) {
				case Add, Mult, LessThan, Equals:
					var p1 = rget(param(), cell.mode1);
					var p2 = rget(param(), cell.mode2);

					var v = switch (cell.opcode) {
						case Add: p1 + p2;
						case Mult: p1 * p2;
						case LessThan: boolToInt(p1 < p2);
						case Equals: boolToInt(p1 == p2);
						default: throw "invalid";
					}

					rset(param(), cell.mode3, v);
				case Input:
					rset(param(), cell.mode1, inputs.shift());
				case Output:
					return Some(rget(param(), cell.mode1));
				case JumpTrue, JumpFalse:
					var p1 = rget(param(), cell.mode1);
					var p2 = rget(param(), cell.mode2);
					if (cell.opcode == JumpTrue ? p1 != 0 : p1 == 0) {
						pointer = Std.int(p2);
					}
				case AdjusteRelativeBase:
					var p1 = rget(param(), cell.mode1);
					base += Std.int(p1);
				case Halt:
					halted = true;
					return None;
				case unknown:
					throw 'unknown opcode "$unknown"';
			}
		}
	}

	function readAccess(j:Int):Float {
		while (j >= memory.length) {
			memory.push(0);
		}
		return memory[j];
	}

	function writeAccess(j:Int, v:Float):Float {
		while (j >= memory.length) {
			memory.push(0);
		}
		return memory[j] = v;
	}

	function rget(j:Int, mode:OpMode):Float {
		return switch (mode) {
			case Immediate:
				readAccess(j);
			case Position:
				readAccess(Std.int(readAccess(j)));
			case Relative:
				readAccess(base + Std.int(readAccess(j)));
		}
	}

	inline function rset(j:Int, mode:OpMode, v:Float) {
		switch (mode) {
			case Immediate:
				throw "no set in immediate mode";
			case Position:
				writeAccess(Std.int(readAccess(j)), v);
			case Relative:
				writeAccess(base + Std.int(readAccess(j)), v);
		}
	}

	inline function param() {
		return pointer++;
	}

	function parseOpCode(code:Float) {
		var code = Std.int(code);
		var modifiers = Std.int(code / 100);
		var code = code - modifiers * 100;
		var modifiers = StringTools.lpad(Std.string(modifiers), "0", 3);

		function getMode(m:String) {
			return switch (m) {
				case "1": Immediate;
				case "2": Relative;
				default: Position;
			}
		}

		return {
			opcode: code,
			mode1: getMode(modifiers.charAt(2)),
			mode2: getMode(modifiers.charAt(1)),
			mode3: getMode(modifiers.charAt(0)),
		}
	}

	inline function boolToInt(b:Bool) {
		return b ? 1 : 0;
	}
}
