pub const EMPTY = ' ';
pub const WIDTH = 50;
pub const HEIGHT = 50;

const FrameError = error{DebugOutOfBounds};

pub const Frame = struct {
    debugline: [WIDTH]u8,
    debug_offset: u8,
    vals: [HEIGHT][WIDTH]u21,

    pub fn init() Frame {
        const debugline = [_]u8{' '} ** WIDTH;
        const vals: [HEIGHT][WIDTH]u21 = [_][WIDTH]u21{[_]u21{EMPTY} ** WIDTH} ** HEIGHT;
        return Frame{ .debug_offset = 0, .debugline = debugline, .vals = vals };
    }

    pub fn append_debug(self: *Frame, msg: []const u8) !void {
        if ((WIDTH - self.debug_offset) < msg.len) {
            return FrameError.DebugOutOfBounds;
        }

        for (0.., msg) |i, c| {
            self.debugline[self.debug_offset + i] = c;
        }
        self.debug_offset += @intCast(msg.len);
    }

    pub fn reset_debug(self: *Frame) void {
        self.debugline = [_]u8{' '} ** WIDTH;
        self.debug_offset = 0;
    }
};

pub const Sprite = struct {
    ptr: *anyopaque,
    impl: *const Interface,

    pub const Interface = struct {
        draw: *const fn (ctx: *anyopaque, x: f32, y: f32, frame: *Frame) void,
        update: *const fn (ctx: *anyopaque) void,
        active: *const fn (ctx: *anyopaque) bool,
    };

    pub fn draw(self: Sprite, x: f32, y: f32, frame: *Frame) void {
        return self.impl.draw(self.ptr, x, y, frame);
    }

    pub fn update(self: Sprite) void {
        return self.impl.update(self.ptr);
    }

    pub fn active(self: Sprite) bool {
        return self.impl.active(self.ptr);
    }
};

