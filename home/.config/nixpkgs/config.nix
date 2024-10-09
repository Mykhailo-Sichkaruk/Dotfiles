{
  allowUnfree = true;
  glibc = {
    locales = [ "en_US.UTF-8" "en_GB.UTF-8" ]; # Add any other locales you need
  };

  # Extra environment variables for Nix packages
  extraEnv = {
    LOCALE_ARCHIVE = "${(import <nixpkgs> {}).glibcLocales}/lib/locale/locale-archive";
  };
}
