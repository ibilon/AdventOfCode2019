package days;

class Day09 {
	static function run(input:Int):Float {
		var memory = IntCodeVM.loadProgram("data/day09.txt");
		var output = new IntCodeVM(memory, [input]).allOutput();

		if (output.length != 1) {
			throw "test fail";
		}

		return output[0];
	}

	public static function part1():Float {
		return run(1);
	}

	public static function part2():Float {
		return run(2);
	}
}
