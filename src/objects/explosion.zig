const std = @import("std");
const drawf = @import("../draw.zig");
const spritef = @import("../sprites/explosion.zig");

pub const Explosion = struct {
    x: f32,
    y: f32,
    allocator: std.mem.Allocator,
    sprites: std.ArrayList(drawf.Sprite),
    is_alive: bool,

    pub fn init(x: f32, y: f32, allocator: std.mem.Allocator) !Explosion {
        const explSprite = try allocator.create(spritef.Explosion);
        explSprite.* = spritef.Explosion.init();
        const sprite = spritef.Explosion.create(explSprite);

        var sprites = std.ArrayList(drawf.Sprite).init(allocator);
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

    pub fn draw(self: *Explosion, f: *drawf.Frame) void {
        for (self.sprites.items) |sprite| {
            sprite.draw(self.x, self.y, f);
        }
    }

    pub fn alive(self: *Explosion) bool {
        return self.is_alive;
    }
};
