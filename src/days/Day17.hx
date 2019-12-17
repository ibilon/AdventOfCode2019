package days;

class Day17 {
	public static function part1():Int {
		var map = [[]];

		for (code in IntCodeVM.runProgram("data/day17.txt").allOutput()) {
			switch (Std.int(code)) {
				case 10: // \n
					map.push([]);
				case 35: // #
					map[map.length - 1].push(true);
				case 46: // .
					map[map.length - 1].push(false);
			}
		}

		var sum = 0;

		for (y in 1...map.length - 3) {
			for (x in 1...map[y].length - 1) {
				final u = map[y - 1][x];
				final d = map[y + 1][x];
				final l = map[y][x - 1];
				final r = map[y][x + 1];
				final c = map[y][x];

				if (u && d && l && r && c) {
					sum += x * y;
				}
			}
		}

		return sum;
	}

	public static function part2():Int {
		return 0;
	}
}
