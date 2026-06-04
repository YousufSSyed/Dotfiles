{ pkgs }:

let
  fonts = builtins.path {
    path = /home/yousuf/Assets/Fonts;
    sha256 = "sha256-HBcCAVIIp3Q/NKBMxfN5xcZZeYxjWVxYk2RfcKeiWaI=";
  };
in
pkgs.runCommandLocal "fonts" { } ''
  mkdir -p $out/share/fonts/truetype
  cp -r ${fonts}/* $out/share/fonts/truetype/
''
