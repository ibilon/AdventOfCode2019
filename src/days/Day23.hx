package days;

class Day23 {
	static function run(is_part1:Bool):Int {
		var memory = IntCodeVM.loadProgram("data/day23.txt");
		var network = [];
		var queue = [];
		var nat = [-1.0, -1.0];
		var nat_history0 = -1.0;
		var nat_history1 = -1.0;

		for (i in 0...50) {
			network.push(new IntCodeVM(memory, [i]));
			queue.push([]);
		}

		while (true) {
			var idle = true;

			for (i in 0...50) {
				var c = network[i];

				if (queue[i].length == 0) {
					c.input(-1);
				} else {
					var msg = queue[i].shift();
					c.inputs(msg);
					idle = false;
				}

				while (true) {
					switch ([c.output(), c.output(), c.output()]) {
						case [Some(y), Some(x), Some(255)]:
							if (is_part1) {
								return Std.int(y);
							}
							nat[0] = x;
							nat[1] = y;
							idle = false;

						case [Some(y), Some(x), Some(a)]:
							queue[Std.int(a)].push([x, y]);
							idle = false;

						case [WaitingForInput, WaitingForInput, WaitingForInput]:
							break;

						default:
							throw 'error on $i';
					}
				}
			}

			if (idle) {
				queue[0].push(nat);
				nat_history0 = nat_history1;
				nat_history1 = nat[1];

				if (nat_history0 == nat_history1) {
					return Std.int(nat_history0);
				}
			}
		}
	}

	public static function part1():Int {
		return run(true);
	}

	public static function part2():Int {
		return run(false);
	}
}
