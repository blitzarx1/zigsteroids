const std = @import("std");
const Sprite = @import("../draw.zig").Sprite;
const Frame = @import("../draw.zig").Frame;
const engineTypes = @import("../engine/types.zig");
const PlayerDirectedSprite = @import("../sprites/player_directed.zig").PlayerDirected;

pub const Player = struct {
    x: f32,
    y: f32,
    speed: f32 = 1,
    dir: engineTypes.Direction = engineTypes.Direction.Up,
    is_alive: bool = true,
    is_moving: bool = false,
    allocator: std.mem.Allocator,

    sprites: std.ArrayList(Sprite),

    pub fn init(x: f32, y: f32, allocator: std.mem.Allocator) !Player {
        const upSprite = try allocator.create(PlayerDirectedSprite);
        upSprite.* = PlayerDirectedSprite.init(0);
        const sprite = PlayerDirectedSprite.create(upSprite);

        var sprites = std.ArrayList(Sprite).init(allocator);
        try sprites.append(sprite);

        return Player{ .x = x, .y = y, .sprites = sprites, .allocator = allocator };
    }

    pub fn update(self: *Player) void {
        self.sprites.clearRetainingCapacity();

        switch (self.dir) {
            engineTypes.Direction.Left => {
                if (self.is_moving) {
                    self.x -= self.speed;
                }

                const pd = self.allocator.create(PlayerDirectedSprite) catch {
                    return;
                };
                pd.* = PlayerDirectedSprite.init(3);
                const sprite = PlayerDirectedSprite.create(pd);

                self.sprites.append(sprite) catch {
                    return;
                };
            },
            engineTypes.Direction.Right => {
                if (self.is_moving) {
                    self.x += self.speed;
                }

                const pd = self.allocator.create(PlayerDirectedSprite) catch {
                    return;
                };
                pd.* = PlayerDirectedSprite.init(2);
                const sprite = PlayerDirectedSprite.create(pd);

                self.sprites.append(sprite) catch {
                    return;
                };
            },
            engineTypes.Direction.Up => {
                if (self.is_moving) {
                    self.y -= self.speed;
                }

                const pd = self.allocator.create(PlayerDirectedSprite) catch {
                    return;
                };
                pd.* = PlayerDirectedSprite.init(0);
                const sprite = PlayerDirectedSprite.create(pd);

                self.sprites.append(sprite) catch {
                    return;
                };
            },
            engineTypes.Direction.Down => {
                if (self.is_moving) {
                    self.y += self.speed;
                }

                const pd = self.allocator.create(PlayerDirectedSprite) catch {
                    return;
                };
                pd.* = PlayerDirectedSprite.init(1);
                const sprite = PlayerDirectedSprite.create(pd);

                self.sprites.append(sprite) catch {
                    return;
                };
            },
        }

        if (self.sprites.items.len == 0) {
            self.is_alive = false;
        }
    }

    pub fn draw(self: *Player, f: *Frame) void {
        for (self.sprites.items) |sprite| {
            sprite.draw(self.x, self.y, f);
        }
    }

    pub fn alive(self: *Player) bool {
        return self.is_alive;
    }

    pub fn set_dir(self: *Player, dir: engineTypes.Direction) void {
        self.dir = dir;
        self.is_moving = true;
    }
};
