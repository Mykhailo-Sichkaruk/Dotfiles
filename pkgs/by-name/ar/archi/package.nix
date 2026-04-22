{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  jdk,
  libsecret,
  glib,
  webkitgtk_4_1,
  wrapGAppsHook3,
  copyDesktopItems,
  makeDesktopItem,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "Archi";
  version = "5.8.0";

  src = {
    "x86_64-linux" = fetchurl {
      url = "https://github.com/archimatetool/archi.io/releases/download/${finalAttrs.version}/Archi-Linux64-${finalAttrs.version}.tgz";
      hash = "sha256-IZFYZRhby3ojBomX3uUuzDS8wQVDfi+XjM12Rz/iyec=";
    };
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  buildInputs = [
    libsecret
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    makeWrapper
    wrapGAppsHook3
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin" "$out/libexec"
    for f in configuration features p2 plugins Archi.ini; do
      cp -r "$f" "$out/libexec"
    done

    install -D -m755 Archi "$out/libexec/Archi"
    makeWrapper "$out/libexec/Archi" "$out/bin/Archi" \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          glib
          webkitgtk_4_1
        ]
      } \
      --set WEBKIT_DISABLE_DMABUF_RENDERER 1 \
      --prefix PATH : ${jdk}/bin

    install -Dm444 icon.xpm "$out/share/icons/hicolor/256x256/apps/archi.xpm"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "archi";
      desktopName = "Archi";
      exec = "Archi";
      type = "Application";
      comment = finalAttrs.meta.description;
      icon = "archi";
      categories = [ "Development" ];
    })
  ];

  meta = {
    description = "ArchiMate modelling toolkit";
    longDescription = ''
      Archi is an open source modelling toolkit to create ArchiMate
      models and sketches.
    '';
    homepage = "https://www.archimatetool.com/";
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "Archi";
  };
})
