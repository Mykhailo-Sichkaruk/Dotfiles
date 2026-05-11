{ config, ... }:

{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = builtins.fromTOML ''
      format = """
      $sudo\
      $shlvl\
      $singularity\
      $kubernetes\
      $directory\
      $vcsh\
      $fossil_branch\
      $fossil_metrics\
      $git_branch\
      $git_commit\
      $git_state\
      $git_metrics\
      $git_status\
      $hg_branch\
      $pijul_channel\
      $docker_context\
      $package\
      $c\
      $cmake\
      $cobol\
      $daml\
      $dart\
      $deno\
      $dotnet\
      $elixir\
      $elm\
      $erlang\
      $fennel\
      $gleam\
      $golang\
      $guix_shell\
      $haskell\
      $haxe\
      $helm\
      $java\
      $julia\
      $kotlin\
      $gradle\
      $lua\
      $nim\
      $nodejs\
      $ocaml\
      $opa\
      $perl\
      $php\
      $pulumi\
      $purescript\
      $python\
      $quarto\
      $raku\
      $rlang\
      $red\
      $ruby\
      $rust\
      $scala\
      $solidity\
      $swift\
      $terraform\
      $typst\
      $vlang\
      $vagrant\
      $zig\
      $buf\
      $nix_shell\
      $conda\
      $meson\
      $spack\
      $memory_usage\
      $aws\
      $openstack\
      $azure\
      $nats\
      $direnv\
      $env_var\
      $crystal\
      $custom\
      $cmd_duration\
      $hostname\
      $localip\
      $line_break\
      $jobs\
      $battery\
      $time\
      $status\
      $os\
      $container\
      $shell\
      $character"""

      [hostname]
      ssh_only = true
      ssh_symbol = " "
      detect_env_vars = ['SSH_CONNECTION']
      disabled = false
      format = "\n [$ssh_symbol](bold blue) on [$hostname](bold blue) "

      [localip]
      ssh_only = true
      format = '@[$localipv4](bold blue) '
      disabled = false

      [git_branch]
      format = "[$symbol$branch]($style)"
      symbol = " "
      style = "bold purple"
      truncation_length = 1000
      truncation_symbol = "…"
      only_attached = false
      ignore_branches = []
      disabled = false

      [fossil_branch]
      format = "[$symbol$branch]($style)"
      symbol = " "
      style = "bold purple"
      truncation_length = 1000
      truncation_symbol = "…"
      disabled = false

      [username]
      style_user = 'white bold'
      style_root = 'black bold'
      format = 'user: [$user]($style) '
      disabled = false
      show_always = false
      aliases = { "corpuser034g" = "matchai" }

      [aws]
      symbol = "  "

      [buf]
      symbol = " "

      [c]
      symbol = " "

      [conda]
      symbol = " "

      [crystal]
      symbol = " "

      [dart]
      symbol = " "

      [directory]
      read_only = " 󰌾"

      [sudo]
      format = "[$symbol]($style) "
      symbol = 'SUDO'
      style = 'bold red'
      disabled = false

      [docker_context]
      symbol = " "

      [elixir]
      symbol = " "

      [elm]
      symbol = " "

      [fennel]
      symbol = " "

      [golang]
      symbol = " "

      [guix_shell]
      symbol = " "

      [haskell]
      symbol = " "

      [haxe]
      symbol = " "

      [hg_branch]
      symbol = " "

      [java]
      symbol = " "

      [julia]
      symbol = " "

      [kotlin]
      symbol = " "

      [lua]
      symbol = " "

      [memory_usage]
      symbol = "󰍛 "

      [meson]
      symbol = "󰔷 "

      [nim]
      symbol = "󰆥 "

      [nix_shell]
      symbol = " "

      [nodejs]
      symbol = " "

      [ocaml]
      symbol = " "

      [os.symbols]
      Alpaquita = " "
      Alpine = " "
      AlmaLinux = " "
      Amazon = " "
      Android = " "
      Arch = " "
      Artix = " "
      CentOS = " "
      Debian = " "
      DragonFly = " "
      Emscripten = " "
      EndeavourOS = " "
      Fedora = " "
      FreeBSD = " "
      Garuda = "󰛓 "
      Gentoo = " "
      HardenedBSD = "󰞌 "
      Illumos = "󰈸 "
      Kali = " "
      Linux = " "
      Mabox = " "
      Macos = " "
      Manjaro = " "
      Mariner = " "
      MidnightBSD = " "
      Mint = " "
      NetBSD = " "
      NixOS = " "
      OpenBSD = "󰈺 "
      openSUSE = " "
      OracleLinux = "󰌷 "
      Pop = " "
      Raspbian = " "
      Redhat = " "
      RedHatEnterprise = " "
      RockyLinux = " "
      Redox = "󰀘 "
      Solus = "󰠳 "
      SUSE = " "
      Ubuntu = " "
      Unknown = " "
      Void = " "
      Windows = "󰍲 "

      [package]
      symbol = "󰏗 "

      [perl]
      symbol = " "

      [php]
      symbol = " "

      [pijul_channel]
      symbol = " "

      [python]
      symbol = " "

      [rlang]
      symbol = "󰟔 "

      [ruby]
      symbol = " "

      [rust]
      symbol = "󱘗 "

      [scala]
      symbol = " "

      [swift]
      symbol = " "

      [zig]
      symbol = " "
    '';
  };

  home.file."${config.xdg.configHome}/starship.toml".force = true;
}
