package days;

import sys.io.File;

class Day12 {
	static function iabs(a:Int):Int {
		return a < 0 ? -a : a;
	}

	static function parse() {
		var moons = {
			x: [],
			y: [],
			z: [],
			vx: [],
			vy: [],
			vz: [],
		};

		for (line in File.getContent("data/day12.txt").split("\n")) {
			var line = line.substring(1, line.length - 1).split(", ").map(e -> e.split("="));

			moons.x.push(Std.parseInt(line[0][1]));
			moons.y.push(Std.parseInt(line[1][1]));
			moons.z.push(Std.parseInt(line[2][1]));

			moons.vx.push(0);
			moons.vy.push(0);
			moons.vz.push(0);
		}

		return moons;
	}

	static inline function compare(a:Int, b:Int):Int {
		return a < b ? 1 : (a > b ? -1 : 0);
	}

	static inline function update(p:Array<Int>, v:Array<Int>) {
		for (i in 0...p.length) {
			p[i] += v[i];
		}
	}

	public static function part1():Int {
		var moons = parse();

		for (_ in 0...1000) {
			for (i1 in 0...moons.x.length) {
				for (i2 in i1 + 1...moons.x.length) {
					var cx = compare(moons.x[i1], moons.x[i2]);
					moons.vx[i1] += cx;
					moons.vx[i2] -= cx;

					var cy = compare(moons.y[i1], moons.y[i2]);
					moons.vy[i1] += cy;
					moons.vy[i2] -= cy;

					var cz = compare(moons.z[i1], moons.z[i2]);
					moons.vz[i1] += cz;
					moons.vz[i2] -= cz;
				}
			}

			update(moons.x, moons.vx);
			update(moons.y, moons.vy);
			update(moons.z, moons.vz);
		}

		var total = 0;

		for (i in 0...moons.x.length) {
			var pot = iabs(moons.x[i]) + iabs(moons.y[i]) + iabs(moons.z[i]);
			var kin = iabs(moons.vx[i]) + iabs(moons.vy[i]) + iabs(moons.vz[i]);
			total += pot * kin;
		}

		return total;
	}

	public static function part2():Int {
		var moons = parse();

		inline function allAt(a:Array<Int>, v:Int):Bool {
			var all = true;

			for (e in a) {
				if (e != v) {
					all = false;
					break;
				}
			}

			return all;
		}

		function cycleLength(p:Array<Int>, v:Array<Int>):Int {
			var length = 0;

			while (true) {
				++length;

				if (length % 1000000 == 0) {
					trace(length);
				}

				for (i1 in 0...p.length) {
					for (i2 in i1 + 1...p.length) {
						var c = compare(p[i1], p[i2]);
						v[i1] += c;
						v[i2] -= c;
					}
				}

				update(p, v);

				if (allAt(v, 0)) {
					return length * 2;
				}
			}
		}

		var cx = cycleLength(moons.x, moons.vx);
		var cy = cycleLength(moons.y, moons.vy);
		var cz = cycleLength(moons.z, moons.vz);

		Sys.command("xdg-open", ['https://www.wolframalpha.com/input/?i=lcm+of+$cx%2C+$cy%2C+$cz']);

		return 0;
	}
}
