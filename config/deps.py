"""
os level dependencies for this project
"""

packages = [
    "bash-static",
    "shellcheck",
    "libncurses5-dev",
    "gcc-arm-linux-gnueabi",
    "gcc-arm-linux-gnueabihf",
    "qemu-system-arm",
    "qemu-utils",
    "qemu-efi-aarch64",
    "qemu-system",
    "busybox",
    "cloud-image-utils",
    "genisoimage", # for mkisofs(1), genisoimage(1)
    "device-tree-compiler",
    # ruby stuff
    "ruby-bundler",
    "rbenv",
]
