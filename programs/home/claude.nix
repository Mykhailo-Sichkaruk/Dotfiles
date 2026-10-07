{ config, lib, ... }:

let
  dotfilesClaude = "${config.home.homeDirectory}/newDot/Dotfiles/home/.claude";
  personalClaude = "${config.home.homeDirectory}/.claude";

  linkInto = dir: target: name: {
    name = "${dir}/${name}";
    value.source = config.lib.file.mkOutOfStoreSymlink "${target}/${name}";
  };

  fromDotfiles = [
    "CLAUDE.md"
    "settings.json"
    "mcp.json"
    "plugins"
    "skills"
    "starship.toml"
    "statusline-command.sh"
  ];

  fromPersonal = [
    "keybindings.json"
    "chrome"
  ];
in
{
  home.file = lib.listToAttrs (
    map (linkInto ".claude-uniit" dotfilesClaude) fromDotfiles
    ++ map (linkInto ".claude-uniit" personalClaude) fromPersonal
  );
}
