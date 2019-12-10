package days;

import sys.io.File;

typedef AMap = {
	final asteroids:Array<Array<Bool>>;
	final width:Int;
	final height:Int;
}

class Day10 {
	static inline function iabs(a:Int):Int {
		return a < 0 ? -a : a;
	}

	static function gcd(a:Int, b:Int):Int {
		var a = iabs(a);
		var b = iabs(b);

		if (a == 0) {
			return b;
		}

		if (b == 0) {
			return a;
		}

		function divisors(i:Int) {
			return [for (j in 1...i + 1) if (i % j == 0) j];
		}

		var da = divisors(a);
		var db = divisors(b).filter(e -> da.indexOf(e) != -1);

		return db[db.length - 1];
	}

	static function parse():AMap {
		final asteroids = File.getContent("data/day10.txt").split("\n").map(e -> e.split("").map(e -> e == "#"));
		final height = asteroids.length;
		final width = asteroids[0].length;

		return {asteroids: asteroids, height: height, width: width};
	}

	static function sights(map:AMap, x:Int, y:Int):Array<String> {
		var angles = new Map<String, Bool>();

		for (oy in 0...map.height) {
			for (ox in 0...map.width) {
				if ((ox == x && oy == y) || !map.asteroids[oy][ox]) {
					continue;
				}

				var dx = ox - x;
				var dy = oy - y;
				var d = gcd(dx, dy);
				dx = Std.int(dx / d);
				dy = Std.int(dy / d);

				angles.set('$dx $dy', true);
			}
		}

		return [for (a in angles.keys()) a];
	}

	public static function part1() {
		var map = parse();
		var max = 0;

		for (y in 0...map.height) {
			for (x in 0...map.width) {
				if (!map.asteroids[y][x]) {
					continue;
				}

				var count = Lambda.count(sights(map, x, y));

				if (count >= max) {
					max = count;
				}
			}
		}

		return max;
	}

	public static function part2():Int {
		return 0;
	}
}
