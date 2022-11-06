{ pkgs }:
  pkgs.stdenvNoCC.mkDerivation {
    name = "lucide-font";
    dontConfigue = true;
    src = pkgs.fetchzip {
      url = "https://github.com/lucide-icons/lucide/releases/download/v0.98.0/lucide-font-0.98.0.zip";
      sha256 = "sha256-HLQwCrrnJWkv77vKuqAVd69o03qRoF/zAmkRCNe9OAQ=";
      stripRoot = false;
    };
    installPhase = ''
      mkdir -p $out/share/fonts/lucide
      cp -R $src/lucide-font/* $out/share/fonts/lucide/
    '';
    meta = { description = "Lucide Icon Font Family derivation."; };
  }