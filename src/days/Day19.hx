package days;

class Day19 {
	public static function part1():Int {
		var vm = IntCodeVM.runProgram("data/day19.txt");
		var count = 0;
		var min_x = 0;

		for (y in 0...50) {
			var has_x = false;
			var min_line = -1;

			for (x in min_x...50) {
				var vm = vm.clone();
				vm.input(y);
				vm.input(x);

				if (vm.allOutput()[0] == 1) {
					has_x = true;
					++count;
				} else if (has_x) {
					break;
				} else {
					min_line = x + 1;
				}
			}

			if (min_line != 51) {
				min_x = min_line;
			}
		}

		return count;
	}

	public static function part2():Int {
		return 0;
	}
}
