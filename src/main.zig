const std = @import("std");
const objectsfile = @import("objects.zig");
const drawf = @import("draw.zig");
const term = @import("term.zig");
const input = @import("input.zig");
const engine = @import("engine.zig");
const objectsf = @import("objects.zig");

// const Texture = union(enum) {
//     explosion: Explosion,

//     pub fn add_to_frame(self: Texture, frame: *Frame) void {
//         switch (self) {
//             i else => |tex| return tex.add_to_frame(frame),
//         }
//     }
// };

fn render(frame: *const drawf.Frame) !void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try stdout.print("\x1b[2J", .{}); // clear screen
    try stdout.print("\x1b[H", .{}); // move cursor to top left corner

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
    std.time.sleep(100_000_000);

    state.handle_input();
    state.gen_frame();

    state.frame_cnt += 1;

    // add randim explosion
    if (state.frame_cnt % 10 == 0) {
        const seed: u64 = @intCast(std.time.nanoTimestamp());
        var rng = std.rand.DefaultPrng.init(seed);

        const x: f32 = rng.random().float(f32) * drawf.WIDTH;
        const y: f32 = rng.random().float(f32) * drawf.HEIGHT;
        var explosion = objectsf.Explosion.init(x, y);

        try state.spawn_object(engine.Object{ .explosion = &explosion });
    }

    try render(state.frame);
}

pub fn main() !void {
    std.debug.print("\x1b[?25l", .{}); // hide cursor
    defer std.debug.print("\x1b[?25h", .{}); // show cursor

    try term.set_raw_mode(true); // read single inputs
    defer {
        _ = term.set_raw_mode(false) catch 0;
    }

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    const objects = std.ArrayList(engine.Object).init(allocator);

    var frame = drawf.Frame.init();

    var st = engine.State{ .objects = objects, .frame = &frame };
    defer st.deinit();

    const st_ptr: *engine.State = &st;

    // input thread
    var input_thread = try std.Thread.spawn(.{}, input.input_thread_fn, .{st_ptr});
    input_thread.detach();

    // game loop
    while (st_ptr.active) try update(st_ptr);
}
