package days;

import sys.io.File;

class Day02 {
	static function run(memory:Array<Int>, noun:Int, verb:Int):Int {
		var memory = memory.copy();
		var i = 0;

		memory[1] = noun;
		memory[2] = verb;

		inline function rget(j:Int):Int {
			return memory[memory[j]];
		}

		inline function rset(j:Int, v:Int) {
			memory[memory[j]] = v;
		}

		while (true) {
			switch (memory[i]) {
				case 1:
					rset(i + 3, rget(i + 1) + rget(i + 2));
				case 2:
					rset(i + 3, rget(i + 1) * rget(i + 2));
				case 99:
					break;
			}

			i += 4;
		}

		return memory[0];
	}

	public static function part1():Int {
		var memory = File.getContent("data/day02.txt").split(",").map(Std.parseInt);
		return run(memory, 12, 2);
	}

	public static function part2():Int {
		var memory = File.getContent("data/day02.txt").split(",").map(Std.parseInt);

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
