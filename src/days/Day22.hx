package days;

import sys.io.File;

class Day22 {
	public static function part1():Int {
		final size = 10007;
		var c2019 = 2019;

		for (instr in File.getContent("data/day22.txt").split("\n").map(e -> e.split(" "))) {
			c2019 = if (instr[0] == "cut") {
				var n = Std.parseInt(instr[1]);
				if (n > 0) {
					(c2019 + size - n) % size;
				} else {
					(c2019 - n) % size;
				}
			} else if (instr[1] == "with") {
				(c2019 * Std.parseInt(instr[3])) % size;
			} else {
				size - c2019 - 1;
			}
		}

		return c2019;
	}

	public static function part2():Int {
		return 0;
	}
}
