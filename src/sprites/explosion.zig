const std = @import("std");
const drawf = @import("../draw.zig");

pub const Explosion = struct {
    frames: [6][5][5]u21 = [6][5][5]u21{
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

    frame_i: u8 = 0,

    pub fn init() Explosion {
        return .{};
    }

    pub fn create(self: *Explosion) drawf.Sprite {
        return drawf.Sprite{
            .ptr = self,
            .impl = &.{ .update = update, .active = active, .draw = draw },
        };
    }

    pub fn update(ctx: *anyopaque) void {
        const self: *Explosion = @ptrCast(@alignCast(ctx));

        self.frame_i += 1;
    }

    pub fn active(ctx: *anyopaque) bool {
        const self: *Explosion = @ptrCast(@alignCast(ctx));

        return self.frame_i < self.frames.len;
    }

    pub fn draw(ctx: *anyopaque, x: f32, y: f32, f: *drawf.Frame) void {
        const self: *Explosion = @ptrCast(@alignCast(ctx));

        const tex_x: u8 = @intFromFloat(x);
        const tex_y: u8 = @intFromFloat(y);

        const frame = self.frames[self.frame_i];
        for (0.., frame) |row_i, st_row| {
            for (0.., st_row) |col_i, st_sym| {
                const row = tex_y + row_i;
                const col = tex_x + col_i;
                if (row < f.vals.len and col < f.vals[0].len) {
                    f.vals[row][col] = st_sym;
                }
            }
        }
    }
};
