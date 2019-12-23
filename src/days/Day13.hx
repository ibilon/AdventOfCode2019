package days;

class Day13 {
	public static function part1():Int {
		var vm = IntCodeVM.runProgram("data/day13.txt");
		var blocks = new Map<String, Bool>();

		while (true) {
			switch ([vm.output(), vm.output(), vm.output()]) {
				case [Some(b), Some(x), Some(y)]:
					final id = '$x $y';
					if (b == 2) {
						blocks.set(id, true);
					} else if (blocks.exists(id)) {
						blocks.remove(id);
					}

				case [Halted, Halted, Halted]:
					return Lambda.count(blocks);

				default:
					throw "unexpected output";
			}
		}
	}

	public static function part2():Int {
		var vm = IntCodeVM.runProgram("data/day13.txt");
		vm.memory[0] = 2;

		var score = 0;
		var paddle = 0;

		while (true) {
			switch ([vm.output(), vm.output(), vm.output()]) {
				case [Some(s), Some(0), Some(-1)]:
					score = Std.int(s);

				case [Some(3), Some(_), Some(x)]:
					paddle = Std.int(x);

				case [Some(4), Some(_), Some(x)]:
					vm.input(Reflect.compare(x, paddle));

				case [Some(_), Some(_), Some(_)]:

				case [Halted, Halted, Halted]:
					return score;

				default:
					throw "unexpected output";
			}
		}
	}
}
