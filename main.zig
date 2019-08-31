const std = @import("std");
const io = std.io;
const warn = std.debug.warn;
const assert = std.debug.assert;
const pow = std.math.pow;

var input: []const u8 = undefined;

var cur_pos: u32 = 0;

pub fn main() void {
    const result = calc("2 ** 3");
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
    assert(calc("99999999999999999 - 1") == 99999999999999998);
}

test "mul" {
    assert(calc("1024 * 1024") == 1048576);
    assert(calc("2 * 2 * 2 * 2") == 16);
}

test "div" {
    assert(calc("30 / 7") == 4);
    assert(calc("30 / 7 / 2") == 2);
}

test "paren" {
    assert(calc("(3 + 3)") == 6);
    assert(calc("5 * (3 + 3)") == 30);
    assert(calc("((5 + 3) * 3)") == 24);
    assert(calc("20 * ((5 + 3) * 3)") == 480);
}

test "pow" {
    assert(calc("2 ** 10") == 1024);
    assert(calc("2 ** 10 ** 2") == 1048576);
}

test "mix" {
    assert(calc("2 + 3 * 4") == 14);
    assert(calc("2 * 3 + 4") == 10);
    assert(calc("2 * 4 + 5 * 6") == 38);
    assert(calc("2 + 4 * 5 + 6") == 28);
}

fn calc(input_: []const u8) i64 {
    input = input_;
    cur_pos = 0;
    return add();
}

fn add() i64 {
    var lhs = mul();

    var c = curChar();
    while (c == '+' or c == '-') {
        nextPos();
        if (c == '+') {
            lhs += mul();
        } else {
            lhs -= mul();
        }
        c = curChar();
    }

    return lhs;
}

fn mul() i64 {
    var lhs = num();

    var c = curChar();
    while (c == '*' or c == '/') {
        nextPos();
        if (c == '*') {
            if (curChar() == '*') {
                nextPos();
                lhs = pow(i64, lhs, num());
            } else {
                lhs *= num();
            }
        } else {
            lhs = @divFloor(lhs, num());
        }
        c = curChar();
    }

    return lhs;
}

fn num() i64 {
    skip();
    var c = curChar();
    if (c == '(') {
        nextPos();
        var n = add();
        nextPos();
        return n;
    }

    var n = i64(c - '0');
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
    if (input.len <= cur_pos) {
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