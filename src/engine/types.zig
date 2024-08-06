const std = @import("std");
const drawf = @import("../draw.zig");
const playerf = @import("../objects/player.zig");
const explosionf = @import("../objects/explosion.zig");

pub const Object = union(enum) {
    player: *playerf.Player,
    explosion: *explosionf.Explosion,

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

pub const Direction = enum { Left, Up, Right, Down };
