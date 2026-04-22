{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation {
  pname = "archi-mcp-plugin";
  version = "0.3.0";

  src = fetchurl {
    url = "https://github.com/Diozavr/archi-mcp-plugin/releases/download/v0.3.0/ru.cinimex.archimatetool.mcp_0.3.0.release.jar";
    hash = "sha256-pfaOUW6CoiBCLdqbSLa0MJ5g6rBXWleNU7euNdop5mc=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/archi-dropins"
    install -Dm444 "$src" "$out/share/archi-dropins/ru.cinimex.archimatetool.mcp_0.3.0.release.jar"

    runHook postInstall
  '';

  meta = {
    description = "MCP plugin dropin for Archi";
    homepage = "https://github.com/Diozavr/archi-mcp-plugin";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
  };
}
