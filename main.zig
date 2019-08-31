const std = @import("std");
const io = std.io;
const warn = std.debug.warn;
const assert = std.debug.assert;

// `input` want to be got from STDIN.
var input: []const u8 = undefined;

var cur_pos: u32 = 0;

pub fn main() void {
    const result = calc("12 + 34");
    warn("{} = {}\n", input, result);
}

test "add" {
    assert(calc(" 1+1 ") == 2);
    assert(calc("10+3") == 13);
    assert(calc("12 + 34") == 46);
    assert(calc("99999999999999999 + 9999999999999999") == 109999999999999998);
}

test "sub" {
    assert(calc("1-1") == 0);
    assert(calc("1 - 2") == -1);
    assert(calc("120 - 210") == -90);
}

fn calc(input_: []const u8) i64 {
    input = input_;
    cur_pos = 0;
    return add();
}

fn add() i64 {
    var lhs = num();

    var c = curChar();
    while (c == '+' or c == '-') {
        nextPos();
        if (c == '+') {
            lhs += num();
        } else {
            lhs -= num();
        }
        c = curChar();
    }

    return lhs;
}

fn num() i64 {
    skip();
    var n = i64(curChar() - '0');
    nextPos();
    while (isDigit(curChar())) {
        n = n * 10 + i64(curChar() - '0');
        nextPos();
    }
    skip();
    return n;
}

fn skip() void {
    while (curChar() == ' ') {
        nextPos();
    }
}

fn curChar() u8 {
    if (input.len <=cur_pos) {
        return 0;
    }
    return input[cur_pos];
}

fn nextPos() void {
    cur_pos += 1;
}

fn isDigit(c: u8) bool {
    return ('0' <= c) and (c <= '9');
}