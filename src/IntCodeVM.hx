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
	var Halt = 99;
}

enum OpMode {
	Position;
	Immediate;
}

class IntCodeVM {
	public static function parseProgram(data:String):Array<Int> {
		return data.split(",").map(Std.parseInt);
	}

	public static function loadProgram(path:String):Array<Int> {
		return parseProgram(File.getContent(path));
	}

	public var memory:Array<Int>;

	var inputs:Array<Int>;
	var pointer:Int;

	public function new(memory:Array<Int>, inputs:Array<Int>) {
		this.memory = memory.copy();
		this.inputs = inputs;
		this.pointer = 0;
	}

	public function input(i:Int) {
		inputs.push(i);
	}

	public function allOutput():Array<Int> {
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

	public function output():Option<Int> {
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

					rset(param(), v);
				case Input:
					rset(param(), inputs.shift());
				case Output:
					return Some(rget(param(), cell.mode1));
				case JumpTrue, JumpFalse:
					var p1 = rget(param(), cell.mode1);
					var p2 = rget(param(), cell.mode2);
					if (cell.opcode == JumpTrue ? p1 != 0 : p1 == 0) {
						pointer = p2;
					}
				case Halt:
					return None;
				case unknown:
					throw 'unknown opcode "$unknown"';
			}
		}
	}

	inline function rget(j:Int, mode:OpMode) {
		return mode == Immediate ? memory[j] : memory[memory[j]];
	}

	inline function rset(j:Int, v:Int) {
		memory[memory[j]] = v;
	}

	inline function param() {
		return pointer++;
	}

	inline function parseOpCode(code:Int) {
		var modifiers = Std.int(code / 100);
		var code = code - modifiers * 100;

		return {
			opcode: code,
			mode1: modifiers & 1 == 0 ? Position : Immediate,
			mode2: modifiers & 10 == 0 ? Position : Immediate,
			mode3: modifiers & 100 == 0 ? Position : Immediate,
		}
	}

	inline function boolToInt(b:Bool) {
		return b ? 1 : 0;
	}
}
