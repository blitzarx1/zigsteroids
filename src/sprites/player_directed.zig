const Sprite = @import("../draw.zig").Sprite;
const Frame = @import("../draw.zig").Frame;

pub const PlayerDirected = struct {
    variants: [4][1][1]u21 = [4][1][1]u21{
        [1][1]u21{[1]u21{'^'}},
        [1][1]u21{[1]u21{'v'}},
        [1][1]u21{[1]u21{'>'}},
        [1][1]u21{[1]u21{'<'}},
    },
    variant: u8,

    pub fn init(variant: u8) PlayerDirected {
        return .{ .variant = variant };
    }

    pub fn create(self: *PlayerDirected) Sprite {
        return Sprite{
            .ptr = self,
            .impl = &.{ .update = update, .active = active, .draw = draw },
        };
    }

    pub fn update(_: *anyopaque) void {}

    pub fn active(_: *anyopaque) bool {
        return true;
    }

    pub fn draw(ctx: *anyopaque, x: f32, y: f32, f: *Frame) void {
        const self: *PlayerDirected = @ptrCast(@alignCast(ctx));

        const tex_x: u8 = @intFromFloat(x);
        const tex_y: u8 = @intFromFloat(y);

        const frame = self.variants[self.variant];
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
