package days;

import sys.io.File;

class Day01 {
	static inline function requiredFeul(mass:Int):Int {
		var fuel = Math.floor(mass / 3) - 2;
		return fuel < 0 ? 0 : fuel;
	}

	public static function part1():Int {
		var fuel = 0;

		for (module in File.getContent("data/day01.txt").split("\n")) {
			fuel += requiredFeul(Std.parseInt(module));
		}

		return fuel;
	}

	public static function part2():Int {
		var fuel = 0;

		for (module in File.getContent("data/day01.txt").split("\n")) {
			var mass = Std.parseInt(module);

			while (mass > 0) {
				mass = requiredFeul(mass);
				fuel += mass;
			}
		}

		return fuel;
	}
}
