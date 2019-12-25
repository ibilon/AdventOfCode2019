package days;

import sys.io.File;

private enum Tile {
	// Entrance;
	Wall;
	Passage;
	Key(v:String);
	Door(v:String);
}

private typedef Grid = Array<Array<Tile>>;

private class Point {
	public final x:Int;
	public final y:Int;

	public inline function new(x:Int, y:Int) {
		this.x = x;
		this.y = y;
	}

	public inline function toString():String {
		return '<$x, $y>';
	}
}

private enum Direction {
	North;
	South;
	West;
	East;
}

private class DirectionTools {
	public inline static function opposite(d:Direction):Direction {
		return switch (d) {
			case North: South;
			case South: North;
			case West: East;
			case East: West;
		}
	}
}

private class Walker {
	final checked:Map<String, Bool>;
	final grid:Grid;
	var pos:Point;
	var dir:Direction;

	public var steps(default, null):Int;

	public function new(checked:Map<String, Bool>, grid:Grid, pos:Point, dir:Direction) {
		this.checked = checked;
		this.grid = grid;
		this.pos = pos;
		this.dir = dir;
		this.steps = 0;
	}

	function apply(dir:Direction) {
		return switch (dir) {
			case North: new Point(pos.x, pos.y - 1);
			case South: new Point(pos.x, pos.y + 1);
			case West: new Point(pos.x - 1, pos.y);
			case East: new Point(pos.x + 1, pos.y);
		};
	}

	public inline function advance() {
		pos = apply(dir);
		checked.set(pos.toString(), true);
		++steps;
	}

	public inline function at():Tile {
		return atPos(pos);
	}

	inline function atPos(pos:Point):Tile {
		return grid[pos.y][pos.x];
	}

	public function spawn():Array<Walker> {
		final spawns = [];
		final dirs = [North, South, West, East];
		dirs.remove(DirectionTools.opposite(dir));

		for (d in dirs) {
			var p = apply(d);
			if (atPos(p) == Wall || checked.exists(p.toString())) {
				continue;
			}

			var s = new Walker(checked, grid, pos, d);
			s.steps = steps;
			spawns.push(s);
		}

		return spawns;
	}
}

class Day18 {
	public static function part1():Int {
		final data = "#########\n#b.A.@.a#\n#########";
		final data = "########################\n#f.D.E.e.C.b.A.@.a.B.c.#\n######################.#\n#d.....................#\n########################";
		final data = "########################\n#...............b.C.D.f#\n#.######################\n#.....@.a.B.c.d.A.e.F.g#\n########################";
		// final data = "#################\n#i.G..c...e..H.p#\n########.########\n#j.A..b...f..D.o#\n########@########\n#k.E..a...g..B.n#\n########.########\n#l.F..d...h..C.m#\n#################";
		// final data = "########################\n#@..............ac.GI.b#\n###d#e#f################\n###A#B#C################\n###g#h#i################\n########################";
		final data = File.getContent("data/day18.txt");

		final grid = [[]];
		var doors = [];
		var keys = []; // TODO need pos for doors and keys?
		var entrance = null;

		for (c in data.split("")) {
			switch (c) {
				case "@":
					// grid[grid.length - 1].push(Entrance);
					grid[grid.length - 1].push(Door("@"));
					entrance = new Point(grid[grid.length - 1].length - 1, grid.length - 1);
				case "\n":
					grid.push([]);
				case "#":
					grid[grid.length - 1].push(Wall);
				case ".":
					grid[grid.length - 1].push(Passage);
				case door if (door.toUpperCase() == door):
					grid[grid.length - 1].push(Door(door.toLowerCase()));
					doors.push({
						pos: new Point(grid[grid.length - 1].length - 1, grid.length - 1),
						value: door,
					});
				case key:
					grid[grid.length - 1].push(Key(key));
					keys.push({
						pos: new Point(grid[grid.length - 1].length - 1, grid.length - 1),
						value: key,
					});
			}
		}

		// trace(keys.length);

		function walk(start:Point):Array<{to:String, steps:Int}> {
			var accessible = [];
			var checked = new Map<String, Bool>();

			final walkers = [
				new Walker(checked, grid, start, North),
				new Walker(checked, grid, start, South),
				new Walker(checked, grid, start, West),
				new Walker(checked, grid, start, East),
			];

			while (walkers.length > 0) {
				final walker = walkers.pop();
				walker.advance();

				switch walker.at() {
					case Wall:
					// do nothing

					// case Entrance:
					//	accessible.push({to: "@", steps: walker.steps});

					case Key(v), Door(_.toUpperCase() => v):
						accessible.push({to: v, steps: walker.steps});

					case Passage:
						for (s in walker.spawn()) {
							walkers.push(s);
						}
				}
			}

			return accessible;
		}

		var accessible = new Map<String, Array<{to:String, steps:Int}>>();

		for (from in [{pos: entrance, value: "@"}].concat(keys).concat(doors)) {
			accessible.set(from.value, walk(from.pos));
			// trace("from ", from.value, accessible.get(from.value));
		}

		/*
			function accessibleWithKeys(from:String, keys:Array<String>, rejecting:Array<String>):Array<{to:String, steps:Int}> {
				// trace("awk", from, keys);
				var acc = accessible.get(from).copy();
				var changed = true;
				// trace(acc);

				rejecting.push(from);

				while (changed) {
					changed = false;

					for (a in acc) {
						if (rejecting.indexOf(a.to) != -1) {
							continue;
						}

						if (keys.indexOf(a.to.toLowerCase()) != -1) {
							acc.remove(a);
							rejecting.push(a.to);

							for (aa in accessibleWithKeys(a.to, keys, rejecting)) {
								if (!Lambda.exists(acc, e -> e.to == aa.to) && keys.indexOf(aa.to) == -1 && aa.to != from) {
									acc.push({
										to: aa.to,
										steps: aa.steps + a.steps,
									});
								}
							}

							changed = true;
							// trace("changed", acc);
						}
					}
				}

				// trace("done", acc);

				return acc;
			}
		 */

		var min = 99999999;

		// TODO might need to precompute the path from all keys to all keys
		// TODO get all perms of keys, check if valid, compute steps

		// trace("accessible", Lambda.count(accessible));
		// return 0;

		var acc_paths = new Map<String, Array<Array<String>>>();

		function path(from:String, current:Array<String>, original:String) {
			// trace("pathing", from, current);
			var deadEnd = true;

			for (a in accessible[from]) {
				if (current.indexOf(a.to) == -1) {
					path(a.to, current.concat([a.to]), original);
					deadEnd = false;
				}
			}

			if (deadEnd) {
				if (!acc_paths.exists(original)) {
					acc_paths[original] = [];
				}

				acc_paths[original].push(current);
			}
		}

		function startPath(from:String) {
			path(from, [from], from);
		}

		startPath("@");

		for (k in keys) {
			startPath(k.value);
		}

		for (d in doors) {
			// startPath(d.value);
		}

		// trace("acc_paths", Lambda.count(acc_paths));

		var key2key = new Map<String, {keys:Array<String>, steps:Int}>();
		var key2key_keys = [for (k in acc_paths.keys()) k].concat(["@"]);

		for (p1 in key2key_keys) {
			for (p2 in key2key_keys) {
				if (p1 == p2) {
					continue;
				}

				for (p in acc_paths[p1]) {
					var i = p.indexOf(p2);

					if (i == -1) {
						continue;
					}

					var doors = [];
					var steps = 0;

					for (j in 1...i + 1) {
						var c = p[j];

						if (c.toUpperCase() == c) {
							doors.push(c.toLowerCase());
						}

						for (a in accessible[p[j - 1]]) {
							if (a.to == c) {
								steps += a.steps;
							}
						}
					}

					key2key['$p1 $p2'] = if (doors.indexOf(p2) == -1) {
						{keys: doors, steps: steps};
					} else {
						{keys: [], steps: -1};
					}
				}
			}
		}

		// trace("key2key", Lambda.count(key2key));

		function go(path:Array<String>, steps:Int) {
			if (steps > min) {
				return;
			}

			var l = path[path.length - 1];
			var okeys = key2key_keys.filter(k -> path.indexOf(k) == -1 && key2key['$l $k'].steps != -1);
			okeys.sort((a, b) -> key2key['$l $a'].steps - key2key['$l $b'].steps);

			for (k in okeys) {
				var p = key2key['$l $k'];
				var valid = true;

				for (rk in p.keys) {
					if (path.indexOf(rk) == -1) {
						valid = false;
						break;
					}
				}

				if (!valid) {
					continue;
				}

				var npath = path.concat([k]);
				var nsteps = steps + p.steps;

				// trace("valid", '$l -> $k = ${p.steps}', nsteps);

				if (npath.length == keys.length + 1) {
					if (nsteps < min) {
						trace("new min", nsteps, npath);
						min = nsteps;
					} else {
						// trace("greater", nsteps, npath);
					}
				} else {
					go(npath, nsteps);
				}
			}
		}

		trace("ready");
		go(["@"], 0);

		return min;

		// TODO compute for each pair of key the doors and step count

		function accessibleWithKeys(from:String, keys:Array<String>):Map<String, Int> {
			var acc = new Map<String, Int>();

			for (p in acc_paths[from]) {
				var steps = 0;

				for (i in 1...p.length) {
					var pc = p[i - 1];
					var c = p[i];

					steps += Lambda.find(accessible[pc], e -> e.to == c).steps;

					if (c.toUpperCase() == c && keys.indexOf(c.toLowerCase()) == -1) {
						// can't pass door
						break;
					} else if (c.toLowerCase() == c && keys.indexOf(c) == -1) {
						acc[c] = steps;
						break;
					}
				}
			}

			return acc;
		}

		var paths = [{at: "@", steps: 0, keys: ["@"]}];

		var s = 0;

		var dot = new StringBuf(); // TODO make dot file with new min/bigger, adding p -> n for all pairs (for i in 0...lenght-1) p[i] -> p[i + 1]
		// render it and check
		dot.add("digraph graphname {\n");

		while (paths.length > 0) {
			// trace(paths);

			var p = paths.pop();
			var a = accessibleWithKeys(p.at, p.keys);

			for (k in a.keys()) {
				var steps = p.steps + a[k];

				if (steps > min) {
					continue;
				}

				if (p.keys.length == keys.length) {
					if (steps < min) {
						min = steps;
						trace("new min", min, p.keys, k);
					} else {
						trace("bigger", steps, p.keys, k);
					}

					var k = p.keys.concat([k]);
					++s;

					for (i in 0...k.length - 1) {
						dot.add('"${k[i]}_$s" -> "${k[i + 1]}_$s";\n');
					}
				} else {
					paths.push({
						at: k,
						steps: steps,
						keys: p.keys.concat([k]),
					});
				}
			}
		}

		dot.add("}\n");
		/*
			File.saveContent("/tmp/test.dot", dot.toString());
			Sys.command("dot", ["-Tpng", "-o/tmp/test.png", "/tmp/test.dot"]);
			Sys.command("gwenview", ["/tmp/test.png"]);
		 */
		/*
			while (paths.length > 0) {
				var p = paths.pop();

				for (to in accessibleWithKeys(p.at, p.keys, [])) {
					var np = {
						at: to.to,
						steps: p.steps + to.steps,
						keys: p.keys.copy(),
					};

					if (np.steps > min) {
						continue;
					}

					if (to.to.toUpperCase() == to.to && p.keys.indexOf(to.to.toLowerCase()) == -1) {
						continue;
					}

					if (to.to.toLowerCase() == to.to && p.keys.indexOf(to.to) == -1) {
						np.keys.push(to.to);
					}

					if (np.keys.length == keys.length + 1) {
						if (np.steps < min) {
							min = np.steps;
							trace("new min", min);
						} else {
							trace("bigger", np.steps);
						}
					} else {
						paths.push(np);
					}
				}
			}
		 */

		return min;
	}

	public static function part2():Int {
		return 0;
	}
}
