package days;

import sys.io.File;

class Day07 {
	static function permutations(min:Int, max:Int):Array<Array<Int>> {
		var perms = [[min, min + 1], [min + 1, min]];

		for (i in 2...max - min + 1) {
			var np = [];
			for (j in 0...i + 1) {
				for (p in perms) {
					var pp = [j + min];
					for (k in p) {
						if (k == j + min) {
							pp.push(i + min);
						} else {
							pp.push(k);
						}
					}
					np.push(pp);
				}
			}
			perms = np;
		}

		return perms;
	}

	public static function part1():Int {
		var memory = File.getContent("data/day07.txt").split(",").map(Std.parseInt);
		var max = 0;

		for (phase in permutations(0, 4)) {
			var i = 0;

			for (p in phase) {
				i = Day05.run(memory.copy(), [p, i]);
			}

			if (i > max) {
				max = i;
			}
		}

		return max;
	}

	public static function part2():Int {
		return 0;
	}
}
