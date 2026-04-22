{
  alsa-lib,
  at-spi2-atk,
  autoPatchelfHook,
  cairo,
  cups,
  dbus,
  expat,
  fetchzip,
  fontconfig_file,
  glib,
  gobject-introspection,
  lib,
  libGL,
  libgbm,
  libgcc,
  libxkbcommon,
  makeWrapper,
  nspr,
  nss,
  pango,
  patchelf,
  pciutils,
  revision,
  browserVersion,
  stdenv,
  systemd,
  vulkan-loader,
  xorg,
}:

stdenv.mkDerivation {
  pname = "playwright-chromium";
  version = revision;

  src = fetchzip {
    url = "https://cdn.playwright.dev/builds/cft/${browserVersion}/linux64/chrome-linux64.zip";
    hash = "sha256-RFVE2u2j/CEnFUbcpBr4zvvf9VCrUpQzExeA+MH3+ek=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    autoPatchelfHook
    patchelf
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    cairo
    cups
    dbus
    expat
    glib
    gobject-introspection
    libgbm
    libgcc
    libxkbcommon
    nspr
    nss
    pango
    stdenv.cc.cc.lib
    systemd
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
    xorg.libxcb
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/chrome-linux64"
    cp -R chrome-linux64/. "$out/chrome-linux64"

    wrapProgram "$out/chrome-linux64/chrome" \
      --set-default SSL_CERT_FILE /etc/ssl/certs/ca-bundle.crt \
      --set-default FONTCONFIG_FILE ${fontconfig_file}

    runHook postInstall
  '';

  appendRunpaths = lib.makeLibraryPath [
    libGL
    vulkan-loader
    pciutils
  ];

  postFixup = ''
    if [ -e "$out/chrome-linux64/libvulkan.so.1" ]; then
      rm "$out/chrome-linux64/libvulkan.so.1"
      ln -s -t "$out/chrome-linux64" "${lib.getLib vulkan-loader}/lib/libvulkan.so.1"
    fi
  '';
}
