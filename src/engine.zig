const std = @import("std");
const drawf = @import("draw.zig");
const objectsf = @import("objects.zig");

pub const State = struct {
    frame_cnt: usize = 0,
    frame: *drawf.Frame = undefined,
    objects: std.ArrayList(Object) = undefined,
    input: ?u8 = null,
    active: bool = true,

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
        while (i > 0) : (i -= 1) {
            const obj = &self.objects.items[i];
            if (obj.alive()) {
                obj.draw(self.frame);
                obj.update();
            } else {
                _ = self.objects.swapRemove(i);
            }
        }
    }

    pub fn handle_input(self: *State) void {
        if (self.input) |key| {
            switch (key) {
                'q' => self.active = false,
                else => {},
            }

            self.input = null;
        } else {}
    }
};

pub const Object = union(enum) {
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
