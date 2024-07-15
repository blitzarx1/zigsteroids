const std = @import("std");
const drawf = @import("draw.zig");

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
