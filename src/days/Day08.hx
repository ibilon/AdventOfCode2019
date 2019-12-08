package days;

import sys.io.File;

class Day08 {
	static inline var WIDTH = 25;
	static inline var HEIGHT = 6;

	static function load():Array<Array<Int>> {
		var layers = [[]];

		for (d in File.getContent("data/day08.txt").split("")) {
			if (layers[layers.length - 1].length == WIDTH * HEIGHT) {
				layers.push([]);
			}
			layers[layers.length - 1].push(Std.parseInt(d));
		}

		return layers;
	}

	public static function part1():Int {
		var layers = load();

		var min = 2147483647;
		var layer = -1;
		var result = -1;

		for (i in 0...layers.length) {
			var count0 = 0;
			var count1 = 0;
			var count2 = 0;

			for (d in layers[i]) {
				switch (d) {
					case 0:
						++count0;
					case 1:
						++count1;
					case 2:
						++count2;
				}
			}

			if (count0 < min) {
				min = count0;
				layer = i;
				result = count1 * count2;
			}
		}

		return result;
	}

	public static function part2():Int {
		var layers = load();
		var buf = new StringBuf();
		buf.add("P1\n");
		buf.add('$WIDTH $HEIGHT\n');

		for (y in 0...HEIGHT) {
			for (x in 0...WIDTH) {
				var r = 2;

				for (l in 0...layers.length) {
					switch (layers[l][y * WIDTH + x]) {
						case 0:
							r = 0;
							break;
						case 1:
							r = 1;
							break;
					}
				}

				buf.add('$r ');
			}
		}

		buf.add("\n");

		var filename = "/tmp/adventofcode2019-day08-image.pbm";
		File.saveContent("/tmp/adventofcode2019-day08-image.pbm", buf.toString());

		Sys.command("gwenview", [filename]);

		return 0;
	}
}
