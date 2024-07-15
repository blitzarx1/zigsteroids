const std = @import("std");
const c = @cImport({
    @cInclude("termios.h");
    @cInclude("unistd.h");
    @cInclude("errno.h");
    @cInclude("fcntl.h");
});

const IOError = error{
    Io,
};

pub fn set_raw_mode(enable: bool) !void {
    const stdin_fd: c_int = 0;
    var termios = c.termios{};
    if (c.tcgetattr(stdin_fd, &termios) != 0) {
        return IOError.Io;
    }
    if (enable) {
        // Set raw mode
        termios.c_lflag &= ~@as(c_uint, c.ICANON);
        termios.c_lflag &= ~@as(c_uint, c.ECHO);
    } else {
        // Restore to original mode
        termios.c_lflag |= @as(c_uint, c.ICANON);
        termios.c_lflag |= @as(c_uint, c.ECHO);
    }

    if (c.tcsetattr(stdin_fd, c.TCSANOW, &termios) != 0) {
        return IOError.Io;
    }
}
