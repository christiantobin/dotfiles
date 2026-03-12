#!/usr/bin/env python3
"""Listen for new window events and auto-size/center them on float-mode workspaces."""

import os
import socket
import subprocess
import time
import sys

STATE_DIR = "/tmp/hypr-float-cache/state"
FLOAT_W = "50%"
FLOAT_H = "50%"

SOCK_PATH = os.path.join(
    os.environ["XDG_RUNTIME_DIR"],
    "hypr",
    os.environ["HYPRLAND_INSTANCE_SIGNATURE"],
    ".socket2.sock",
)


def hyprctl(*args):
    subprocess.run(["hyprctl", *args], capture_output=True)


def handle_openwindow(data):
    # Format: addr,workspace,class,title
    parts = data.split(",", 3)
    if len(parts) < 2:
        return
    addr, ws = parts[0], parts[1]
    state_file = os.path.join(STATE_DIR, f"ws-{ws}")
    if os.path.exists(state_file):
        time.sleep(0.05)
        hyprctl(
            "--batch",
            f"dispatch setfloating address:0x{addr}"
            f" ; dispatch resizewindowpixel exact {FLOAT_W} {FLOAT_H},address:0x{addr}"
            f" ; dispatch centerwindow,address:0x{addr}",
        )


def main():
    s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    s.connect(SOCK_PATH)
    buf = ""
    while True:
        data = s.recv(4096)
        if not data:
            break
        buf += data.decode()
        while "\n" in buf:
            line, buf = buf.split("\n", 1)
            if line.startswith("openwindow>>"):
                handle_openwindow(line[len("openwindow>>"):])


if __name__ == "__main__":
    main()
