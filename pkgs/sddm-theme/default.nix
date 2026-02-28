{
  stdenv,
  stylixColors,
}: let
  c = color: builtins.replaceStrings ["#"] [""] color;
in
  stdenv.mkDerivation {
    pname = "sddm-theme";
    version = "1.0.0";

    src = ../../modules/nixos/desktop/sddm-theme;

    dontBuild = true;

    installPhase = ''
      mkdir -p $out/share/sddm/themes/nixos

      cp logo.svg $out/share/sddm/themes/nixos/logo.svg
      cp metadata.desktop $out/share/sddm/themes/nixos/metadata.desktop

      sed \
        -e 's|@base00@|#${c stylixColors.base00}|g' \
        -e 's|@base05@|#${c stylixColors.base05}|g' \
        -e 's|@base08@|#${c stylixColors.base08}|g' \
        -e 's|@base0D@|#${c stylixColors.base0D}|g' \
        Main.qml > $out/share/sddm/themes/nixos/Main.qml
    '';

    meta.description = "SDDM login theme with Stylix color integration";
  }
