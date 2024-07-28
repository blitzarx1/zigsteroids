const std = @import("std");
const drawf = @import("../draw.zig");
const enginef = @import("../engine.zig");
const spritef = @import("../sprites/player_directed.zig");

pub const Player = struct {
    x: f32,
    y: f32,
    speed: f32 = 1,
    dir: enginef.Direction = enginef.Direction.Up,
    is_alive: bool = true,
    is_moving: bool = false,
    allocator: std.mem.Allocator,

    sprites: std.ArrayList(drawf.Sprite),

    pub fn init(x: f32, y: f32, allocator: std.mem.Allocator) !Player {
        const upSprite = try allocator.create(spritef.PlayerDirected);
        upSprite.* = spritef.PlayerDirected.init(0);
        const sprite = spritef.PlayerDirected.create(upSprite);

        var sprites = std.ArrayList(drawf.Sprite).init(allocator);
        try sprites.append(sprite);

        return Player{ .x = x, .y = y, .sprites = sprites, .allocator = allocator };
    }

    pub fn update(self: *Player) void {
        self.sprites.clearRetainingCapacity();

        switch (self.dir) {
            enginef.Direction.Left => {
                if (self.is_moving) {
                    self.x -= self.speed;
                }

                const pd = self.allocator.create(spritef.PlayerDirected) catch {
                    return;
                };
                pd.* = spritef.PlayerDirected.init(3);
                const sprite = spritef.PlayerDirected.create(pd);

                self.sprites.append(sprite) catch {
                    return;
                };
            },
            enginef.Direction.Right => {
                if (self.is_moving) {
                    self.x += self.speed;
                }

                const pd = self.allocator.create(spritef.PlayerDirected) catch {
                    return;
                };
                pd.* = spritef.PlayerDirected.init(2);
                const sprite = spritef.PlayerDirected.create(pd);

                self.sprites.append(sprite) catch {
                    return;
                };
            },
            enginef.Direction.Up => {
                if (self.is_moving) {
                    self.y -= self.speed;
                }

                const pd = self.allocator.create(spritef.PlayerDirected) catch {
                    return;
                };
                pd.* = spritef.PlayerDirected.init(0);
                const sprite = spritef.PlayerDirected.create(pd);

                self.sprites.append(sprite) catch {
                    return;
                };
            },
            enginef.Direction.Down => {
                if (self.is_moving) {
                    self.y += self.speed;
                }

                const pd = self.allocator.create(spritef.PlayerDirected) catch {
                    return;
                };
                pd.* = spritef.PlayerDirected.init(1);
                const sprite = spritef.PlayerDirected.create(pd);

                self.sprites.append(sprite) catch {
                    return;
                };
            },
        }

        if (self.sprites.items.len == 0) {
            self.is_alive = false;
        }
    }

    pub fn draw(self: *Player, f: *drawf.Frame) void {
        for (self.sprites.items) |sprite| {
            sprite.draw(self.x, self.y, f);
        }
    }

    pub fn alive(self: *Player) bool {
        return self.is_alive;
    }

    pub fn set_dir(self: *Player, dir: enginef.Direction) void {
        self.dir = dir;
        self.is_moving = true;
    }
};
