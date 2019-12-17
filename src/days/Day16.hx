package days;

import sys.io.File;

class Day16 {
	public static function part1():Int {
		var pattern = [0, 1, 0, -1];
		var data = File.getContent("data/day16.txt").split("").map(Std.parseInt);
		var next_data = data.copy();

		var pattern_i = [];

		for (i in 0...data.length) {
			var p = [];

			for (j in 0...pattern.length) {
				for (_ in 0...i + 1) {
					p.push(pattern[j]);
				}
			}

			pattern_i.push(p);
		}

		for (_ in 0...100) {
			for (i in 0...data.length) {
				var sum = 0;

				for (k in 0...data.length) {
					sum += data[k] * pattern_i[i][(k + 1) % pattern_i[i].length];
				}

				var sum = Std.string(sum);
				next_data[i] = Std.parseInt(sum.charAt(sum.length - 1));
			}

			var tmp = data;
			data = next_data;
			next_data = tmp;
		}

		var result = 0;

		for (i in 0...8) {
			result = result * 10 + data[i];
		}

		return result;
	}

	public static function part2():Int {
		var idata = File.getContent("data/day16.txt").split("").map(Std.parseInt);

		var data = [];
		for (_ in 0...10000) {
			for (i in idata) {
				data.push(i);
			}
		}

		var offset = 0;

		for (i in 0...7) {
			offset = offset * 10 + data[i];
		}

		for (_ in 0...100) {
			for (i in 1...data.length - offset) {
				data[data.length - i - 1] = (data[data.length - i] + data[data.length - i - 1]) % 10;
			}
		}

		var result = 0;

		for (i in 0...8) {
			result = result * 10 + data[i + offset];
		}

		return result;
	}
}
