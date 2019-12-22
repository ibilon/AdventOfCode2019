package days;

import haxe.io.Bytes;
import sys.io.File;

abstract UInt16Array(Bytes) {
	public inline function new(size:Int) {
		this = Bytes.alloc(size * 2);
	}

	public inline function blit(pos:Int, src:UInt16Array, srcpos:Int, len:Int) {
		this.blit(pos * 2, (cast src : Bytes), srcpos * 2, len * 2);
	}

	@:arrayAccess inline function get(pos:Int):Int {
		return this.getUInt16(pos * 2);
	}

	@:arrayAccess inline function set(pos:Int, value:Int):Int {
		this.setUInt16(pos * 2, value);
		return value;
	}
}

class Day22 {
	public static function part1():Int {
		final size = 10007;
		var cards = new UInt16Array(size);
		var buf = new UInt16Array(size);

		for (i in 0...size) {
			cards[i] = i;
		}

		for (instr in File.getContent("data/day22.txt").split("\n").map(e -> e.split(" "))) {
			if (instr[0] == "cut") {
				var n = Std.parseInt(instr[1]);

				if (n > 0) {
					buf.blit(0, cards, n, size - n);
					buf.blit(size - n, cards, 0, n);
				} else {
					buf.blit(0, cards, size + n, -n);
					buf.blit(-n, cards, 0, size + n);
				}

				var tmp = cards;
				cards = buf;
				buf = tmp;
			} else if (instr[1] == "with") {
				var n = Std.parseInt(instr[3]);
				var j = -1;

				while (++j < size) {
					buf[(j * n) % size] = cards[j];
				}

				var tmp = cards;
				cards = buf;
				buf = tmp;
			} else {
				for (i in 0...Std.int(size / 2)) {
					var tmp = cards[i];
					cards[i] = cards[size - i - 1];
					cards[size - i - 1] = tmp;
				}
			}
		}

		for (i in 0...size) {
			if (cards[i] == 2019) {
				return i;
			}
		}

		return -1;
	}

	public static function part2():Int {
		return 0;
	}
}
