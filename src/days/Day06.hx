package days;

import sys.io.File;

private typedef OrbitMap = Map<String, String>;

class Day06 {
	static function pathToCom(map:OrbitMap, obj:String):Array<String> {
		var path = [];
		var p;

		do {
			p = map.get(obj);
			obj = p;
			path.push(p);
		} while (p != "COM");

		return path;
	}

	static function orbitMap():OrbitMap {
		var map = new OrbitMap();

		for (orbit in File.getContent("data/day06.txt").split("\n")) {
			var orbit = orbit.split(")");
			map.set(orbit[1], orbit[0]);
		}

		return map;
	}

	public static function part1():Int {
		var map = orbitMap();
		var total = 0;

		for (obj in map.keys()) {
			total += pathToCom(map, obj).length;
		}

		return total;
	}

	public static function part2():Int {
		var map = orbitMap();
		var you = pathToCom(map, "YOU");
		var san = pathToCom(map, "SAN");

		while (you[you.length - 1] == san[san.length - 1]) {
			you.pop();
			san.pop();
		}

		return you.length + san.length;
	}
}
