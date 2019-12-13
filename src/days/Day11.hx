package days;

import haxe.ds.HashMap;

@:using(days.Day11.DirectionTools)
enum Direction {
	Up;
	Left;
	Down;
	Right;
}

class DirectionTools {
	public static function turnLeft(dir:Direction):Direction {
		return switch (dir) {
			case Up: Left;
			case Left: Down;
			case Down: Right;
			case Right: Up;
		}
	}

	public static function turnRight(dir:Direction):Direction {
		return switch (dir) {
			case Up: Right;
			case Left: Up;
			case Down: Left;
			case Right: Down;
		}
	}
}

enum abstract Color(Int) to Int {
	var Black = 0;
	var White = 1;

	@:from static function fromInt(i:Int):Color {
		return switch (i) {
			case Black: Black;
			case White: White;
			default: throw "invalid color";
		}
	}
}

class Point {
	public var x:Int;
	public var y:Int;

	public function new(x:Int, y:Int) {
		this.x = x;
		this.y = y;
	}

	public function hashCode():Int {
		return x * 10000 + y;
	}

	public function advance(dir:Direction) {
		switch (dir) {
			case Up:
				--y;
			case Left:
				--x;
			case Down:
				++y;
			case Right:
				++x;
			default:
				throw "invalid direction";
		}
	}
}

class Day11 {
	static function imin(a:Int, b:Int):Int {
		return a < b ? a : b;
	}

	static function imax(a:Int, b:Int):Int {
		return a > b ? a : b;
	}

	static function run(start:Color):{colored:HashMap<Point, Color>, min:Point, max:Point} {
		var vm = new IntCodeVM(IntCodeVM.loadProgram("data/day11.txt"), []);
		var pos = new Point(0, 0);
		var dir = Up;
		var colored = new HashMap<Point, Color>();
		colored.set(pos, start);

		var min_x = 0;
		var min_y = 0;
		var max_x = 0;
		var max_y = 0;

		while (true) {
			vm.input(colored.get(pos));

			switch ([vm.output(), vm.output()]) {
				case [Some(turn), Some(color)]:
					colored.set(pos, Std.int(color));

					dir = switch (turn) {
						case 0: dir.turnLeft();
						case 1: dir.turnRight();
						default: throw "invalid turn output";
					}

					pos.advance(dir);
					min_x = imin(min_x, pos.x);
					min_y = imin(min_y, pos.y);
					max_x = imax(max_x, pos.x);
					max_y = imax(max_y, pos.y);

					if (!colored.exists(pos)) {
						colored.set(pos, Black);
					}

				case [None, None]:
					return {
						colored: colored,
						min: new Point(min_x, min_y),
						max: new Point(max_x, max_y)
					};

				default:
					throw "error";
			}
		}
	}

	public static function part1():Int {
		return Lambda.count([for (k in run(Black).colored.keys()) k]);
	}

	public static function part2():Int {
		var data = run(White);

		for (y in data.min.y...data.max.y + 1) {
			for (x in data.min.x...data.max.x + 1) {
				var p = new Point(x, y);

				if (data.colored.exists(p) && data.colored.get(p) == White) {
					Sys.print("#");
				} else {
					Sys.print(" ");
				}
			}

			Sys.println("");
		}

		return 0;
	}
}
