package days;

import sys.io.File;
import sys.io.Process;

class Day14 {
	public static function part1():Int {
		var rules = new Array<{i:Map<String, Int>, n:String, q:Int}>();
		var components = new Map<String, Bool>();

		function parseComponent(i:String) {
			var i = i.split(" ");
			components.set(i[1], true);
			return {q: Std.parseInt(i[0]), n: i[1]};
		}

		for (line in File.getContent("data/day14.txt").split("\n").map(e -> e.split(" => "))) {
			var i = [for (i in line[0].split(", ").map(parseComponent)) i.n => i.q];
			var r = parseComponent(line[1]);
			rules.push({i: i, n: r.n, q: r.q});
		}

		rules.push({i: [], n: "ORE", q: 1});
		rules.push({i: ["FUEL" => 1], n: "", q: 0});

		var prog = new StringBuf();
		prog.add('min: rule_${rules.length - 2};\n\n');

		for (c in components.keys()) {
			var req = [for (r in 0...rules.length) if (rules[r].i.exists(c)) '${rules[r].i[c]} rule_$r'].join(" + ");
			var prod = [for (r in 0...rules.length) if (rules[r].n == c) '${rules[r].q} rule_$r'].join(" + ");
			prog.add('$prod >= $req;\n');
		}

		prog.add('\nrule_${rules.length - 1} = 1;\n\n');
		prog.add('int ${[for (r in 0...rules.length) 'rule_$r'].join(", ")};\n');

		var path = "/tmp/aoc_day14.lp";
		File.saveContent(path, prog.toString());

		var process = new Process("lp_solve", ["-S1", path]);
		var out = StringTools.trim(process.stdout.readAll().toString());

		return Std.parseInt(out.substring(out.indexOf(":") + 1, out.indexOf(".")));
	}

	public static function part2():Int {
		return 0;
	}
}
