pub const EMPTY = ' ';
pub const WIDTH = 50;
pub const HEIGHT = 50;

pub const Frame = struct {
    vals: [HEIGHT][WIDTH]u21,

    pub fn init() Frame {
        return Frame{ .vals = [_][WIDTH]u21{[_]u21{EMPTY} ** WIDTH} ** HEIGHT };
    }
};
