package days;

import sys.io.File;

typedef Moon = {
	x:Int,
	y:Int,
	z:Int,
	vx:Int,
	vy:Int,
	vz:Int,
}

class Day12 {
	static function iabs(a:Int):Int {
		return a < 0 ? -a : a;
	}

	public static function part1():Int {
		var moons = new Array<Moon>();

		for (line in File.getContent("data/day12.txt").split("\n")) {
			var line = line.substring(1, line.length - 1).split(", ").map(e -> e.split("="));
			moons.push({
				x: Std.parseInt(line[0][1]),
				y: Std.parseInt(line[1][1]),
				z: Std.parseInt(line[2][1]),
				vx: 0,
				vy: 0,
				vz: 0,
			});
		}

		for (_ in 0...1000) {
			for (i1 in 0...moons.length) {
				var m1 = moons[i1];

				for (i2 in i1 + 1...moons.length) {
					var m2 = moons[i2];

					if (m1.x < m2.x) {
						++m1.vx;
						--m2.vx;
					} else if (m1.x > m2.x) {
						--m1.vx;
						++m2.vx;
					}
					if (m1.y < m2.y) {
						++m1.vy;
						--m2.vy;
					} else if (m1.y > m2.y) {
						--m1.vy;
						++m2.vy;
					}
					if (m1.z < m2.z) {
						++m1.vz;
						--m2.vz;
					} else if (m1.z > m2.z) {
						--m1.vz;
						++m2.vz;
					}
				}
			}

			for (m in moons) {
				m.x += m.vx;
				m.y += m.vy;
				m.z += m.vz;
			}
		}

		var total = 0;

		for (m in moons) {
			var pot = iabs(m.x) + iabs(m.y) + iabs(m.z);
			var kin = iabs(m.vx) + iabs(m.vy) + iabs(m.vz);
			total += pot * kin;
		}

		return total;
	}

	public static function part2():Int {
		return 0;
	}
}
