package days;

class Day19 {
	public static function part1():Int {
		var vm = IntCodeVM.runProgram("data/day19.txt");
		var count = 0;
		var min_x = 0;
		var max_x = 0;

		for (y in 0...50) {
			var min_line = -1;

			for (x in min_x...50) {
				var vm = vm.clone();
				vm.input(y);
				vm.input(x);

				if (vm.allOutput()[0] == 1) {
					min_line = x;
					break;
				}
			}

			if (min_line == -1) {
				continue;
			}

			final max = max_x > min_line ? max_x : min_line;
			var max_line = 50;

			for (x in max...50) {
				var vm = vm.clone();
				vm.input(y);
				vm.input(x);

				if (vm.allOutput()[0] == 0) {
					max_line = x;
					break;
				}
			}

			count += max_line - min_line;
			min_x = min_line;
			max_x = max_line;
		}

		return count;
	}

	public static function part2():Int {
		var vm = IntCodeVM.runProgram("data/day19.txt");
		var min_x = 0;
		var max_x = 0;
		var y = -1;
		var lines_size = [for (_ in 0...100) 0];
		var lines_start = [for (_ in 0...100) 0];
		var lines_index = 0;

		while (true) {
			++y;
			var min_line = -1;
			var x = min_x - 1;

			while (++x < min_x + 20) {
				var vm = vm.clone();
				vm.input(y);
				vm.input(x);

				if (vm.allOutput()[0] == 1) {
					min_line = x;
					break;
				}

				++x;
			}

			if (min_line == -1) {
				continue;
			}

			var x = max_x > min_line ? max_x : min_line;
			var max_line = -1;

			while (true) {
				var vm = vm.clone();
				vm.input(y);
				vm.input(x);

				if (vm.allOutput()[0] == 0) {
					max_line = x;
					break;
				}

				++x;
			}

			min_x = min_line;
			max_x = max_line;

			lines_index = (lines_index + 1) % 100;
			lines_size[lines_index] = max_line - min_line;
			lines_start[lines_index] = min_line;

			var prev_index = (lines_index + 1) % 100;

			if (lines_size[prev_index] - lines_start[lines_index] >= 100) {
				return (y - 99) * 10000 + min_line;
			}

			if (y == 100000) {
				return -1;
			}
		}
	}
}
