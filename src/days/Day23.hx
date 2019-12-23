package days;

class Day23 {
	public static function part1():Int {
		var memory = IntCodeVM.loadProgram("data/day23.txt");
		var network = [];
		var queue = [];

		for (i in 0...50) {
			network.push(new IntCodeVM(memory, [i]));
			queue.push([]);
		}

		while (true) {
			for (i in 0...50) {
				var c = network[i];

				if (queue[i].length == 0) {
					c.input(-1);
				} else {
					var msg = queue[i].shift();
					c.inputs(msg);
				}

				while (true) {
					switch ([c.output(), c.output(), c.output()]) {
						case [Some(y), Some(_), Some(255)]:
							return Std.int(y);

						case [Some(y), Some(x), Some(a)]:
							queue[Std.int(a)].push([x, y]);

						case [WaitingForInput, WaitingForInput, WaitingForInput]:
							break;

						default:
							throw 'error on $i';
					}
				}
			}
		}

		return 0;
	}

	public static function part2():Int {
		return 0;
	}
}
