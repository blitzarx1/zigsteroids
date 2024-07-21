const std = @import("std");
const drawf = @import("draw.zig");

const Direction = enum { Left, Up, Right, Down };

pub const Player = struct {
    x: f32,
    y: f32,
    speed: f32 = 0,
    dir: Direction = Direction.Up,
    is_alive: bool = true,
    steps: [4][1][1]u21 = [4][1][1]u21{
        [1][1]u21{[1]u21{'>'}},
        [1][1]u21{[1]u21{'v'}},
        [1][1]u21{[1]u21{'^'}},
        [1][1]u21{[1]u21{'<'}},
    },

    pub fn init(x: f32, y: f32) Player {
        return Player{ .x = x, .y = y };
    }

    pub fn update(self: *Player) void {
        switch (self.dir) {
            Direction.Left => self.x -= self.speed,
            Direction.Right => self.x += self.speed,
            Direction.Up => self.y -= self.speed,
            Direction.Down => self.y += self.speed,
        }

        self.x += self.speed;
        self.y += self.speed;
    }

    pub fn draw(self: *Player, f: *drawf.Frame) void {
        const tex_x: u8 = @intFromFloat(self.x);
        const tex_y: u8 = @intFromFloat(self.y);

        std.debug.print("drawing player...", .{});

        var step: [1][1]u21 = undefined;
        switch (self.dir) {
            Direction.Left => step = self.steps[3],
            Direction.Right => step = self.steps[0],
            Direction.Up => step = self.steps[2],
            Direction.Down => step = self.steps[1],
        }

        for (0.., step) |row_i, st_row| {
            for (0.., st_row) |col_i, st_sym| {
                const row = tex_y + row_i;
                const col = tex_x + col_i;
                if (row < f.vals.len and col < f.vals[0].len) {
                    f.vals[row][col] = st_sym;
                }
            }
        }
    }

    pub fn alive(self: *Player) bool {
        return self.is_alive;
    }
};

pub const Explosion = struct {
    x: f32,
    y: f32,
    steps: [6][5][5]u21 = [6][5][5]u21{
        [5][5]u21{
            [5]u21{ ' ', ' ', ' ', ' ', ' ' },
            [5]u21{ ' ', ' ', ' ', ' ', ' ' },
            [5]u21{ ' ', ' ', '╬', ' ', ' ' },
            [5]u21{ ' ', ' ', ' ', ' ', ' ' },
            [5]u21{ ' ', ' ', ' ', ' ', ' ' },
        },
        [5][5]u21{
            [5]u21{ ' ', ' ', ' ', ' ', ' ' },
            [5]u21{ ' ', '╲', ' ', '╱', ' ' },
            [5]u21{ ' ', ' ', '╬', ' ', ' ' },
            [5]u21{ ' ', '╱', ' ', '╲', ' ' },
            [5]u21{ ' ', ' ', ' ', ' ', ' ' },
        },
        [5][5]u21{
            [5]u21{ '⋰', ' ', ' ', ' ', '⋱' },
            [5]u21{ ' ', '⨴', ' ', '⨵', ' ' },
            [5]u21{ '⫷', ' ', '⨳', ' ', '⫸' },
            [5]u21{ ' ', '⨴', ' ', '⨵', ' ' },
            [5]u21{ '⋱', ' ', ' ', ' ', '⋰' },
        },
        [5][5]u21{
            [5]u21{ ' ', ' ', ' ', ' ', ' ' },
            [5]u21{ ' ', '╲', ' ', '╱', ' ' },
            [5]u21{ ' ', ' ', '∘', ' ', ' ' },
            [5]u21{ ' ', '╱', ' ', '╲', ' ' },
            [5]u21{ ' ', ' ', ' ', ' ', ' ' },
        },
        [5][5]u21{
            [5]u21{ ' ', ' ', ' ', ' ', ' ' },
            [5]u21{ ' ', ' ', ' ', ' ', ' ' },
            [5]u21{ ' ', ' ', '∘', ' ', ' ' },
            [5]u21{ ' ', ' ', ' ', ' ', ' ' },
            [5]u21{ ' ', ' ', ' ', ' ', ' ' },
        },
        [5][5]u21{
            [5]u21{ ' ', ' ', ' ', ' ', ' ' },
            [5]u21{ ' ', ' ', ' ', ' ', ' ' },
            [5]u21{ ' ', ' ', ' ', ' ', ' ' },
            [5]u21{ ' ', ' ', ' ', ' ', ' ' },
            [5]u21{ ' ', ' ', ' ', ' ', ' ' },
        },
    },

    step: u8,
    is_alive: bool,

    pub fn init(x: f32, y: f32) Explosion {
        return Explosion{ .x = x, .y = y, .is_alive = true, .step = 0 };
    }

    pub fn update(self: *Explosion) void {
        self.step += 1;
        if (self.step == self.steps.len) {
            self.is_alive = false;
        }
    }

    // TODO: extract actual drawing into Texture
    pub fn draw(self: *Explosion, f: *drawf.Frame) void {
        const tex_x: u8 = @intFromFloat(self.x);
        const tex_y: u8 = @intFromFloat(self.y);

        const step = self.steps[self.step];
        for (0.., step) |row_i, st_row| {
            for (0.., st_row) |col_i, st_sym| {
                const row = tex_y + row_i;
                const col = tex_x + col_i;
                if (row < f.vals.len and col < f.vals[0].len) {
                    f.vals[row][col] = st_sym;
                }
            }
        }
    }

    pub fn alive(self: *Explosion) bool {
        return self.is_alive;
    }
};
