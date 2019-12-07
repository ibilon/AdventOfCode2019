package days;

class Day05 {
	static function run(input:Int):Int {
		var memory = IntCodeVM.loadProgram("data/day05.txt");
		var output = new IntCodeVM(memory, [input]).allOutput();

		for (i in 0...output.length - 1) {
			if (output[i] != 0) {
				throw "test fail";
			}
		}

		return output[output.length - 1];
	}

	public static function part1():Int {
		return run(1);
	}

	public static function part2():Int {
		return run(5);
	}
}
