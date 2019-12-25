package days;

import sys.io.File;

private typedef Point = {
	x:Float,
	y:Float,
}

class Day10 {
	static function getVisibilityMap():Map<Point, Array<Array<Point>>> {
		var data = File.getContent("data/day10.txt").split("\n");
		var asteroids = new Array<Point>();

		for (y in 0...data.length) {
			for (x in 0...data[y].length) {
				if (data[y].charAt(x) == "#") {
					asteroids.push({x: x, y: y});
				}
			}
		}

		var visibilityMap = new Map<Point, Array<Array<Point>>>();

		for (asteroid in asteroids) {
			var map = new Map<String, Array<Point>>();

			for (other in asteroids) {
				if (other == asteroid) {
					continue;
				}

				var rpos = {x: other.x - asteroid.x, y: other.y - asteroid.y};
				var len = Math.sqrt(rpos.x * rpos.x + rpos.y * rpos.y);
				rpos.x /= len;
				rpos.y /= len;

				var angle = if (rpos.x == 0 || rpos.y == 0) {
					0.0;
				} else {
					var a = Math.acos(rpos.y < 0 ? -rpos.y : rpos.y) * 180 / Math.PI;

					if (rpos.x > 0) {
						if (rpos.y < 0) {
							a;
						} else {
							180 - a;
						}
					} else {
						if (rpos.y > 0) {
							180 + a;
						} else {
							360 - a;
						}
					}
				}

				var id = Std.string(angle);

				if (!map.exists(id)) {
					map[id] = [];
				}

				map[id].push(other);
			}

			var angles = [for (a in map.keys()) a];
			angles.sort((a, b) -> Reflect.compare(a, b));

			for (a in angles) {
				map[a].sort((a, b) -> Reflect.compare(a.x * a.x + a.y * a.y, b.x * b.x + b.y * b.y));
			}

			visibilityMap.set(asteroid, [for (a in angles) map[a]]);
		}

		return visibilityMap;
	}

	static function monitoringStation(map:Map<Point, Array<Array<Point>>>):Point {
		var max = 0;
		var p = null;

		for (point => views in map) {
			if (views.length > max) {
				max = views.length;
				p = point;
			}
		}

		return p;
	}

	public static function part1() {
		var visibilityMap = getVisibilityMap();
		var station = monitoringStation(visibilityMap);
		for (p => a in visibilityMap) {
			trace(p.x, p.y, a.length);
		}
		trace(station.x, station.y);
		return visibilityMap[station].length;
	}

	public static function part2():Int {
		var visibilityMap = getVisibilityMap();
		var station = monitoringStation(visibilityMap);
		var i = 0;

		while (true) {
			for (a in visibilityMap[station]) {
				var p = a.shift();

				if (++i == 200) {
					return Std.int(p.x) * 100 + Std.int(p.y);
				}
			}
		}
	}
}
