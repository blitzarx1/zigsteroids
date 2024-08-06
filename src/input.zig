const std = @import("std");
const State = @import("engine/state.zig").State;

pub fn input_thread_fn(s: *State) void {
    const stdin = std.io.getStdIn().reader();
    var buf: [1]u8 = undefined;

    while (true) {
        std.time.sleep(10_000_000);

        if (!s.active) {
            return;
        }

        if (stdin.read(&buf)) |bytes_read| {
            if (bytes_read > 0) {
                const key = buf[0];
                s.set_input(key);
            }
        } else |_| {}
    }
}
