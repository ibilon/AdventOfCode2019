package days;

enum abstract Direction(Int) to Int {
	var North = 1;
	var South = 2;
	var West = 3;
	var East = 4;
}

enum abstract Status(Int) to Int {
	var Blocked = 0;
	var Moved = 1;
	var MovedToGoal = 2;
}

@:forward(x, y)
abstract Point({x:Int, y:Int}) {
	public inline function new(x:Int, y:Int) {
		this = {x: x, y: y};
	}

	public inline function applyDir(dir:Direction):Point {
		return switch (dir) {
			case North: new Point(this.x, this.y - 1);
			case South: new Point(this.x, this.y + 1);
			case West: new Point(this.x - 1, this.y);
			case East: new Point(this.x + 1, this.y);
		}
	}

	public inline function clone():Point {
		return new Point(this.x, this.y);
	}

	public inline function toString():String {
		return '${this.x} ${this.y}';
	}
}

class Day15 {
	static inline function imin(a:Int, b:Int):Int {
		return a < b ? a : b;
	}

	static function run():{maze:Map<String, Int>, goal:Point} {
		var runners = [
			for (dir in [North, South, West, East])
				{
					vm: IntCodeVM.runProgram("data/day15.txt"),
					pos: new Point(0, 0),
					dir: dir,
					steps: 0,
				}
		];
		var goal = null;
		var maze = ["0 0" => 0];

		while (runners.length > 0) {
			var runner = runners.pop();
			runner.vm.input(runner.dir);

			switch (runner.vm.output()) {
				case Some(status):
					runner.pos = runner.pos.applyDir(runner.dir);

					var steps = maze.exists(runner.pos.toString()) ? maze[runner.pos.toString()] : 999999;
					maze.set(runner.pos.toString(), status == Blocked ? -1 : imin(runner.steps + 1, steps));

					if (status == Blocked) {
						continue;
					}

					if (status == MovedToGoal) {
						goal = runner.pos.clone();
					}

					for (dir in [North, South, West, East]) {
						var pos = runner.pos.applyDir(dir);

						if (maze.exists(pos.toString()) && maze[pos.toString()] < runner.steps + 2) {
							continue;
						}

						runners.push({
							vm: runner.vm.clone(),
							pos: runner.pos,
							dir: dir,
							steps: runner.steps + 1,
						});
					}

				default:
			}
		}

		return {maze: maze, goal: goal};
	}

	public static function part1():Int {
		var r = run();
		return r.maze[r.goal.toString()];
	}

	public static function part2():Int {
		var r = run();
		r.maze[r.goal.toString()] = -2;
		var oxy = [r.goal];
		var min = 0;

		while (true) {
			var noxy = [];

			for (o in oxy) {
				for (dir in [North, South, West, East]) {
					var npos = o.applyDir(dir);

					switch (r.maze[npos.toString()]) {
						case -1, -2:

						default:
							r.maze[npos.toString()] = -2;
							noxy.push(npos);
					}
				}
			}

			oxy = noxy;

			if (oxy.length > 0) {
				++min;
			} else {
				return min;
			}
		}
	}
}
