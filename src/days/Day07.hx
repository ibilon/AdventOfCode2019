package days;

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

	static function run(phaseOffset:Int):Int {
		var memory = IntCodeVM.loadProgram("data/day07.txt");
		var max = 0;

		for (phase in permutations(phaseOffset, phaseOffset + 4)) {
			var amps = [for (i in 0...5) new IntCodeVM(memory, [phase[i]])];
			var o = 0;
			var run = true;

			while (run) {
				for (amp in amps) {
					amp.input(o);

					switch (amp.output()) {
						case Some(v):
							o = v;
						case None:
							run = false;
					}
				}

				if (o > max) {
					max = o;
				}
			}
		}

		return max;
	}

	public static function part1():Int {
		return run(0);
	}

	public static function part2():Int {
		return run(5);
	}
}
