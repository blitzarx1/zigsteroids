const std = @import("std");
const drawf = @import("draw.zig");
const term = @import("term.zig");
const input = @import("input.zig");
const engine = @import("engine.zig");

fn render(frame: *const drawf.Frame) !void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try stdout.print("\x1b[2J", .{}); // clear screen
    try stdout.print("\x1b[H", .{}); // move cursor to top left corner

    // print debug
    try stdout.print("{s}\n", .{frame.debugline});

    // print the world
    for (frame.vals) |row| {
        for (row) |sym| {
            var buf: [4]u8 = [_]u8{undefined} ** 4;
            _ = try std.unicode.utf8Encode(sym, &buf);
            try stdout.print("{c}{s}", .{ drawf.EMPTY, buf });
        }
        try stdout.print("\n", .{});
    }
    try bw.flush();
}

pub fn update(state: *engine.State) !void {
    try state.update();

    try render(state.frame);
}

pub fn main() !void {
    std.debug.print("\x1b[?25l", .{}); // hide cursor
    defer std.debug.print("\x1b[?25h", .{}); // show cursor

    try term.set_raw_mode(true); // read single inputs
    defer {
        _ = term.set_raw_mode(false) catch null;
    }

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    var st = try engine.State.init(arena.allocator());
    defer st.deinit();

    // input thread
    var input_thread = try std.Thread.spawn(.{}, input.input_thread_fn, .{st});
    defer input_thread.join();

    // game loop
    while (st.active) {
        std.time.sleep(60_000_000);

        try update(st);
    }
}
