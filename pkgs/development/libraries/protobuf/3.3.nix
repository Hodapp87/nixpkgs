{ callPackage, lib, ... }:

lib.overrideDerivation (callPackage ./generic-v3.nix {
  version = "3.3.2";
  sha256 = "1a2s66i3ampwa0yc2mj3b743hcryixqhk1vvskzgyzvglv048cn4";
}) (attrs: { NIX_CFLAGS_COMPILE = "-Wno-error"; })
