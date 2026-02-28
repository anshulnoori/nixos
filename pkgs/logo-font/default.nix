{
  stdenv,
  fontFile,
}:
stdenv.mkDerivation {
  pname = "logo-font";
  version = "1.0.0";

  src = fontFile;

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/fonts/truetype/logo
    cp $src $out/share/fonts/truetype/logo/logo.ttf
  '';

  meta.description = "Custom font with logo glyph for Waybar";
}
