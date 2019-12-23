package days;

import sys.io.File;
import sys.io.Process;

private typedef Data = {
	rules:Array<{i:Map<String, Int>, n:String, q:Int}>,
	components:Map<String, Bool>,
}

class Day14 {
	static function parse():Data {
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

		return {rules: rules, components: components};
	}

	static function printRules(prog:StringBuf, data:Data) {
		var i = 0;
		for (c in data.components.keys()) {
			var req = [
				for (r in 0...data.rules.length)
					if (data.rules[r].i.exists(c)) '${data.rules[r].i[c]} rule_$r'
			].join(" - ");
			var prod = [
				for (r in 0...data.rules.length)
					if (data.rules[r].n == c) '${data.rules[r].q} rule_$r'
			].join(" + ");
			prog.add('  c${++i}: $prod - $req >= 0\n');
		}
	}

	static function solve(path:String):Int {
		var process = new Process("glpsol", ["--lp", path, "-o", "/dev/stdout"]);
		var output = process.stdout.readAll().toString().split("\n");
		process.exitCode();

		for (line in output) {
			if (StringTools.startsWith(line, "Objective:  obj = ")) {
				return Std.parseInt(line.substring(line.indexOf("=") + 2, line.indexOf("(")));
			}
		}

		throw "no solution found";
	}

	public static function part1() {
		var data = parse();
		data.rules.push({i: [], n: "ORE", q: 1});
		data.rules.push({i: ["FUEL" => 1], n: "", q: 0});

		var prog = new StringBuf();
		prog.add('Minimize\n  obj: rule_${data.rules.length - 2}\nSubject To\n');
		prog.add('  c0: rule_${data.rules.length - 1} = 1\n');
		printRules(prog, data);
		prog.add("General\n");
		prog.add([for (r in 0...data.rules.length) '  rule_$r'].join("\n"));
		prog.add("\nEnd\n");

		var path = "/tmp/aoc_day14_part1.cplex";
		File.saveContent(path, prog.toString());
		return solve(path);
	}

	public static function part2():Int {
		var data = parse();
		data.rules.push({i: [], n: "ORE", q: 1});
		data.rules.push({i: ["FUEL" => 1], n: "", q: 0});

		var prog = new StringBuf();
		prog.add('Maximize\n  obj: rule_${data.rules.length - 1}\nSubject To\n');
		prog.add('  c0: rule_${data.rules.length - 2} = 1000000000000\n');
		printRules(prog, data);
		prog.add("General\n");
		prog.add([for (r in 0...data.rules.length) '  rule_$r'].join("\n"));
		prog.add("\nEnd\n");

		var path = "/tmp/aoc_day14_part2.cplex";
		File.saveContent(path, prog.toString());
		return solve(path);
	}
}
