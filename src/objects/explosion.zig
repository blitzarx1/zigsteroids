const std = @import("std");
const Sprite = @import("../draw.zig").Sprite;
const Frame = @import("../draw.zig").Frame;
const ExplosionSprite = @import("../sprites/explosion.zig").Explosion;

pub const Explosion = struct {
    x: f32,
    y: f32,
    allocator: std.mem.Allocator,
    sprites: std.ArrayList(Sprite),
    is_alive: bool,

    pub fn init(x: f32, y: f32, allocator: std.mem.Allocator) !Explosion {
        const explSprite = try allocator.create(ExplosionSprite);
        explSprite.* = ExplosionSprite.init();
        const sprite = ExplosionSprite.create(explSprite);

        var sprites = std.ArrayList(Sprite).init(allocator);
        try sprites.append(sprite);

        return .{
            .x = x,
            .y = y,
            .sprites = sprites,
            .is_alive = true,
            .allocator = allocator,
        };
    }

    pub fn update(self: *Explosion) void {
        var i = self.sprites.items.len - 1;
        while (true) {
            const sprite = self.sprites.items[i];

            sprite.update();

            if (!sprite.active()) {
                _ = self.sprites.swapRemove(i);
            }

            if (i == 0) break;
            i -= 1;
        }

        if (self.sprites.items.len == 0) {
            self.is_alive = false;
        }
    }

    pub fn draw(self: *Explosion, f: *Frame) void {
        for (self.sprites.items) |sprite| {
            sprite.draw(self.x, self.y, f);
        }
    }

    pub fn alive(self: *Explosion) bool {
        return self.is_alive;
    }
};
