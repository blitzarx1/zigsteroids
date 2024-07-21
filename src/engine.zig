const std = @import("std");
const drawf = @import("draw.zig");
const objectsf = @import("objects.zig");

pub const State = struct {
    allocator: std.mem.Allocator,

    frame: *drawf.Frame,

    player: *objectsf.Player,
    objects: std.ArrayList(Object),

    input: ?u8 = null,

    frames_since: u16,
    last_second: i64,

    active: bool = true,

    pub fn init(allocator: std.mem.Allocator) !*State {
        const f = try allocator.create(drawf.Frame);
        f.* = drawf.Frame.init();

        const p = try allocator.create(objectsf.Player);
        p.* = objectsf.Player.init(
            drawf.WIDTH / 2,
            drawf.HEIGHT / 2,
        );

        const st = try allocator.create(State);
        st.* = .{
            .allocator = allocator,
            .objects = std.ArrayList(Object).init(allocator),
            .frame = f,
            .player = p,
            .frames_since = 0,
            .last_second = std.time.timestamp(),
        };

        try st.spawn_object(Object{ .player = p });

        return st;
    }

    pub fn spawn_object(self: *State, obj: Object) !void {
        try self.objects.append(obj);
    }

    pub fn deinit(self: *State) void {
        self.objects.deinit();
    }

    pub fn set_input(self: *State, input: u8) void {
        self.input = input;
    }

    pub fn gen_frame(self: *State) void {
        if (self.objects.items.len == 0) {
            return;
        }

        var i = self.objects.items.len - 1;
        while (true) {
            const obj = &self.objects.items[i];
            std.debug.print("obj: {}", .{obj});
            if (obj.alive()) {
                obj.draw(self.frame);
                obj.update();
            } else {
                _ = self.objects.swapRemove(i);
            }

            if (i == 0) break;
            i -= 1;
        }
    }

    pub fn handle_input(self: *State) !void {
        if (self.input) |key| {
            switch (key) {
                'q' => self.active = false,
                ' ' => {
                    const seed: u64 = @intCast(std.time.nanoTimestamp());
                    var rng = std.rand.DefaultPrng.init(seed);

                    const e = try self.allocator.create(objectsf.Explosion);
                    const x: f32 = rng.random().float(f32) * drawf.WIDTH;
                    const y: f32 = rng.random().float(f32) * drawf.HEIGHT;
                    e.* = objectsf.Explosion.init(x, y);

                    try self.spawn_object(Object{ .explosion = e });
                },
                else => {},
            }

            self.input = null;
        } else {}
    }

    pub fn update(self: *State) !void {
        self.frames_since += 1;

        try self.handle_input();
        self.gen_frame();

        const now = std.time.timestamp();
        const diff = now - self.last_second;
        if (diff > 1) {
            self.frame.reset_debug();

            // Create a buffer to store the formatted string
            var buffer: [32]u8 = undefined;

            // Format the string and write it to the buffer
            const fps_str = try std.fmt.bufPrint(&buffer, "fps: {}", .{self.frames_since});
            try self.frame.append_debug(fps_str);

            self.frames_since = 0;
            self.last_second = now;
        }
    }
};

pub const Object = union(enum) {
    player: *objectsf.Player,
    explosion: *objectsf.Explosion,

    pub fn draw(self: Object, frame: *drawf.Frame) void {
        switch (self) {
            inline else => |obj| return obj.draw(frame),
        }
    }

    pub fn update(self: Object) void {
        switch (self) {
            inline else => |obj| return obj.update(),
        }
    }

    pub fn alive(self: Object) bool {
        switch (self) {
            inline else => |obj| return obj.alive(),
        }
    }
};
