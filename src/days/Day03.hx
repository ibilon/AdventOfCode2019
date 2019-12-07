package days;

import sys.io.File;

class Day03 {
	static inline function iabs(a:Int):Int {
		return a < 0 ? -a : a;
	}

	static function run(dist:(steps:Int, x:Int, y:Int) -> Int):Int {
		var wires = File.getContent("data/day03.txt").split("\n").map(a -> a.split(",").map(e -> {dir: e.substr(0, 1), dist: Std.parseInt(e.substr(1))}));
		var map = new Map<String, Map<Int, Int>>();

		for (wire in 0...wires.length) {
			var x = 0;
			var y = 0;
			var step = 0;

			for (move in wires[wire]) {
				for (_ in 0...move.dist) {
					++step;

					switch (move.dir) {
						case "U":
							--y;
						case "D":
							++y;
						case "L":
							--x;
						case "R":
							++x;
					}

					var id = '$x $y';

					if (!map.exists(id)) {
						map.set(id, [wire => step]);
					} else {
						var smap = map.get(id);

						if (!smap.exists(wire)) {
							smap.set(wire, step);
						}
					}
				}
			}
		}

		var min_dist = 2147483647;
		var x = 0;
		var y = 0;

		for (pos in map.keys()) {
			var smap = map.get(pos);
			if (Lambda.count(smap) > 1) {
				var pos = pos.split(" ").map(Std.parseInt);
				var steps = 0;

				for (wire in smap) {
					steps += wire;
				}

				var d = dist(steps, pos[0], pos[1]);

				if (d < min_dist) {
					min_dist = d;

					x = pos[0];
					y = pos[1];
				}
			}
		}

		return min_dist;
	}

	public static function part1():Int {
		return run((steps, x, y) -> iabs(x) + iabs(y));
	}

	public static function part2():Int {
		return run((steps, x, y) -> steps);
	}
}
