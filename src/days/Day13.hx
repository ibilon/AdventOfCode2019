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

				case [None, None, None]:
					return Lambda.count(blocks);

				default:
					throw "unexpected output";
			}
		}
	}

	public static function part2():Int {
		return 0;
	}
}
