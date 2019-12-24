package days;

import sys.io.File;

typedef Grid = Array<Array<Bool>>;

class Day24 {
	public static function part1():Int {
		function key(grid:Grid):String {
			return grid.map(e -> e.map(f -> f ? "#" : ".").join("")).join("\n");
		}

		function step(grid:Grid):Grid {
			function get(x:Int, y:Int):Bool {
				if (x < 0 || y < 0 || x >= grid[0].length || y >= grid.length) {
					// trace(x, y, false);
					return false;
				}
				// trace(x, y, grid[y][x]);

				return grid[y][x];
			}

			final n = [for (line in grid) line.copy()];

			for (y in 0...grid.length) {
				for (x in 0...grid[0].length) {
					final t = get(x, y - 1) ? 1 : 0;
					final b = get(x, y + 1) ? 1 : 0;
					final l = get(x - 1, y) ? 1 : 0;
					final r = get(x + 1, y) ? 1 : 0;
					final a = t + b + l + r;
					final c = get(x, y);

					if (c) {
						n[y][x] = a == 1;
					} else {
						n[y][x] = a == 1 || a == 2;
					}

					// Sys.print(a);
				}

				// Sys.println("");
			}

			return n;
		}

		function rating(grid:Grid):Int {
			var r = 0;
			var p = 1;

			for (line in grid) {
				for (e in line) {
					if (e) {
						r += p;
					}

					p *= 2;
				}
			}

			return r;
		}

		var grid = File.getContent("data/day24.txt").split("\n").map(e -> e.split("").map(f -> f == "#"));
		final previous = [key(grid) => true];

		while (true) {
			grid = step(grid);
			final hash = key(grid);
			// trace(hash);
			// return 0;

			if (previous.exists(hash)) {
				return rating(grid);
			} else {
				previous[hash] = true;
			}
		}
	}

	public static function part2():Int {
		return 0;
	}
}
