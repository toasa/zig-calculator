const std = @import("std");
const io = std.io;
const warn = std.debug.warn;

// `input` want to be got from STDIN.
const input = "2+3";

var cur_pos: u32 = 0;

pub fn main() void {
    const result = calc();
    warn("{} = {}\n", input, result);
}

fn calc() i64 {
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
    
    var n = curChar() - '0';
    nextPos();
    while (isDigit(curChar())) {
        n = n * 10 + (curChar() - '0');
        nextPos();
    }
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