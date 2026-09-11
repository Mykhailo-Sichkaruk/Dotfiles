{
  config,
  lib,
  localPackages,
  pkgs,
  ...
}:

let
  cfg = config.my.apps.pear;
  jsonFormat = pkgs.formats.json { };

  managedPlugins = lib.mapAttrs (
    _name: pluginCfg: pluginCfg.settings // { enabled = pluginCfg.enable; }
  ) cfg.plugins;

  declarativeSettings = cfg.settings // {
    plugins = managedPlugins;
  };

  configuredPackage = localPackages.mkPearDesktop {
    inherit (cfg) chromiumArgs package;
    settings = declarativeSettings;
  };
in
{
  options.my.apps.pear = {
    enable = lib.mkEnableOption "Pear Desktop with declaratively managed settings";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.pear-desktop;
      defaultText = lib.literalExpression "pkgs.pear-desktop";
      description = "Pear Desktop package to wrap.";
    };

    chromiumArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "--enable-gpu-rasterization" ];
      description = "Additional Chromium arguments passed to Electron.";
    };

    settings = lib.mkOption {
      type = lib.types.attrsOf jsonFormat.type;
      default = { };
      description = ''
        Partial Pear Desktop configuration recursively merged into its writable
        config before every launch. Use the plugins option for plugin settings.
      '';
    };

    plugins = lib.mkOption {
      default = { };
      description = ''
        Pear plugins managed declaratively. Managed values are re-applied before
        every launch; undeclared plugins and other runtime settings remain mutable.
      '';
      type = lib.types.attrsOf (
        lib.types.submodule (
          { name, ... }:
          {
            options = {
              enable = lib.mkEnableOption "the Pear Desktop ${name} plugin";

              settings = lib.mkOption {
                type = lib.types.attrsOf jsonFormat.type;
                default = { };
                description = ''
                  Additional settings for this plugin. The enabled field is
                  generated from the enable option and takes precedence.
                '';
              };
            };
          }
        )
      );
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !(cfg.settings ? plugins);
        message = "my.apps.pear.settings.plugins is unsupported; use my.apps.pear.plugins instead";
      }
    ];

    home.packages = [ configuredPackage ];
  };
}
