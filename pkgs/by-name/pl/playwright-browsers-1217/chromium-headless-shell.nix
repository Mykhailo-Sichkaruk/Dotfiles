{
  alsa-lib,
  at-spi2-atk,
  autoPatchelfHook,
  fetchzip,
  glib,
  libXcomposite,
  libXdamage,
  libXfixes,
  libXrandr,
  libgbm,
  libgcc,
  libxkbcommon,
  nspr,
  nss,
  patchelfUnstable,
  revision,
  browserVersion,
  stdenv,
}:

stdenv.mkDerivation {
  pname = "playwright-chromium-headless-shell";
  version = revision;

  src = fetchzip {
    url = "https://cdn.playwright.dev/builds/cft/${browserVersion}/linux64/chrome-headless-shell-linux64.zip";
    hash = "sha256-kQCw0nQHHuUIfn8rGVcN7Ip6ZOk5c3Or+GG5RvSica4=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    autoPatchelfHook
    patchelfUnstable
  ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    glib
    libXcomposite
    libXdamage
    libXfixes
    libXrandr
    libgbm
    libgcc.lib
    libxkbcommon
    nspr
    nss
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/chrome-headless-shell-linux64"
    cp -R chrome-headless-shell-linux64/. "$out/chrome-headless-shell-linux64"

    if [ -f "$out/chrome-headless-shell-linux64/chrome-headless-shell" ] && [ ! -f "$out/chrome-headless-shell-linux64/headless_shell" ]; then
      ln -s chrome-headless-shell "$out/chrome-headless-shell-linux64/headless_shell"
    fi

    runHook postInstall
  '';
}
