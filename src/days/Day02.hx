package days;

class Day02 {
	static function run(memory:Array<Int>, noun:Int, verb:Int):Int {
		var vm = new IntCodeVM(memory, []);
		vm.memory[1] = noun;
		vm.memory[2] = verb;

		var output = vm.allOutput();

		if (output.length > 0) {
			throw "too much output";
		}

		return vm.memory[0];
	}

	public static function part1():Int {
		var memory = IntCodeVM.loadProgram("data/day02.txt");
		return run(memory, 12, 2);
	}

	public static function part2():Int {
		var memory = IntCodeVM.loadProgram("data/day02.txt");

		for (noun in 0...100) {
			for (verb in 0...100) {
				if (run(memory, noun, verb) == 19690720) {
					return noun * 100 + verb;
				}
			}
		}

		return -1;
	}
}
