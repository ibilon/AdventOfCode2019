package days;

class Day04 {
	static inline var data = "278384-824795";

	static function count(validRepeat:(c:Int) -> Bool):Int {
		var range = data.split("-").map(Std.parseInt);
		var value = 0;

		for (number in range[0]...range[1] + 1) {
			var number = '$number'.split("").map(Std.parseInt);

			var rule2 = [1];

			for (i in 1...number.length) {
				if (number[i] == number[i - 1]) {
					++rule2[rule2.length - 1];
				} else {
					rule2.push(1);
				}
			}

			if (!Lambda.exists(rule2, validRepeat)) {
				continue;
			}

			var rule3 = true;

			for (i in 1...number.length) {
				if (number[i] < number[i - 1]) {
					rule3 = false;
					break;
				}
			}

			if (rule3) {
				++value;
			}
		}

		return value;
	}

	public static function part1():Int {
		return count(c -> c >= 2);
	}

	public static function part2():Int {
		return count(c -> c == 2);
	}
}
