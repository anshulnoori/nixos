# MacBook Pro M2 Pro — Asahi Linux
#
# Partition layout (created by Asahi installer):
#   /dev/nvme0n1p1  Apple APFS / macOS recovery
#   /dev/nvme0n1p2  Apple APFS container (macOS)
#   /dev/nvme0n1p3  EFI System Partition (~500MB, vfat, shared with macOS)
#   /dev/nvme0n1p4  Linux root partition (LUKS2 encrypted)
#
# Setup (run once during install):
#   cryptsetup luksFormat --type luks2 /dev/nvme0n1p4
#   cryptsetup open /dev/nvme0n1p4 cryptroot
#   mkfs.btrfs -L nixos /dev/mapper/cryptroot
#   mount /dev/mapper/cryptroot /mnt
#   btrfs subvolume create /mnt/@
#   btrfs subvolume create /mnt/@home
#   btrfs subvolume create /mnt/@snapshots
#   umount /mnt
#
# Get UUIDs:
#   blkid /dev/nvme0n1p4   → YOUR_LUKS_UUID
#   blkid /dev/nvme0n1p3   → YOUR_EFI_PARTUUID
{
  lib,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  boot.initrd.availableKernelModules = [
    "thunderbolt"
    "nvme"
    "usb_storage"
    "usbhid"
  ];

  boot.initrd.luks.devices."cryptroot" = {
    device = "/dev/disk/by-uuid/YOUR_LUKS_UUID";
    allowDiscards = true;
    preLVM = true;
  };

  boot.kernelParams = ["rootflags=subvol=@"];

  fileSystems."/" = {
    device = "/dev/mapper/cryptroot";
    fsType = "btrfs";
    options = ["subvol=@" "compress=zstd" "noatime"];
  };

  fileSystems."/home" = {
    device = "/dev/mapper/cryptroot";
    fsType = "btrfs";
    options = ["subvol=@home" "compress=zstd" "noatime"];
  };

  fileSystems."/.snapshots" = {
    device = "/dev/mapper/cryptroot";
    fsType = "btrfs";
    options = ["subvol=@snapshots" "compress=zstd" "noatime"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-partuuid/YOUR_EFI_PARTUUID";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  # zram swap configured in modules/nixos/core/default.nix
  swapDevices = [];

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
