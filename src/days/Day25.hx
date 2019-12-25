package days;

class Day25 {
	public static function part1():String {
		var vm = IntCodeVM.runProgram("data/day25.txt");

		while (true) {
			while (true) {
				switch (vm.output()) {
					case Some(v):
						Sys.print(String.fromCharCode(Std.int(v)));
					case WaitingForInput:
						break;
					case Halted:
						return "Game over";
				}
			}

			var line = Sys.stdin().readLine();

			if (line == "exit") {
				return "Thanks for playing";
			}

			vm.inputs(line.split("").map(c -> c.charCodeAt(0) + 0.0));
			vm.input(10);
		}
	}

	public static function part2():Int {
		return 0;
	}
}
