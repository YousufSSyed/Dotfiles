{ pkgs }: pkgs.runCommandLocal "my-iosevka-fonts" {} ''
  mkdir -p $out/share/fonts/truetype
  cp -r ${./Fonts} $out/share/fonts/truetype
''
