{
  pkgs,
  localPackages,
  ...
}:

{
  programs.fish = {
    enable = true;

    shellAliases = {
      rm = "rm -rf";
      e = "eza -ab --group-directories-first --icons";
      ex = "eza -ab --group-directories-first --icons -lTL 1 --no-time --git --no-user";
      ls = "ls --color -L";
      la = "eza";
      l = "ex";
      h = "history 1 | grep";
      cp = "cp -r";
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
      cls = "clear";
      gitclown = "git clone";
    };

    shellAbbrs = {
      nd = "nix develop";
      nr = "sudo nixos-rebuild switch --flake /home/ms/newDot/Dotfiles#MS_NixLaptop";
    };

    functions = {
      fish_mode_prompt.body = "";
      forget_last_command.body = ''
        set -l cmd $history[1]
        if test -z "$cmd"
            echo "No commands in history"
            return
        end
        history delete --exact --case-sensitive -- $cmd
        echo "Last command '$cmd' removed from history"
      '';
    };

    interactiveShellInit = ''
      set -gx PLAYWRIGHT_BROWSERS_PATH "${localPackages.playwrightBrowsers1217}"
      set fish_cursor_insert line
      set fish_greeting

      set -g fish_color_normal ff0000
      set -g fish_color_command bd93f8
      set -g fish_color_keyword ff79c6
      set -g fish_color_quote f1fa8c
      set -g fish_color_redirection f8f8f2
      set -g fish_color_end ffb86c
      set -g fish_color_error ff5555
      set -g fish_color_param 50fa7a
      set -g fish_color_comment 6272a4
      set -g fish_color_selection --background=44475a
      set -g fish_color_search_match --background=44475a
      set -g fish_color_operator bd93f8
      set -g fish_color_escape ff79c6
      set -g fish_color_autosuggestion 6272a4
      set -g fish_color_cancel ff5555 --reverse
      set -g fish_color_option ffb86c
      set -g fish_color_history_current --bold
      set -g fish_color_status ff5555
      set -g fish_color_valid_path --underline
      set -g fish_color_cwd bd93f8
      set -g fish_color_cwd_root red
      set -g fish_color_host 50fa7a
      set -g fish_color_host_remote 50fa7a
      set -g fish_color_user 8be9fd
      set -g fish_pager_color_progress 6272a4
      set -g fish_pager_color_prefix 8be9fd
      set -g fish_pager_color_completion f8f8f2
      set -g fish_pager_color_description 6272a4
      set -g fish_pager_color_selected_background --background=44475a
      set -g fish_pager_color_selected_prefix 8be9fd
      set -g fish_pager_color_selected_completion f8f8f2
      set -g fish_pager_color_selected_description 6272a4
      set -g fish_pager_color_secondary_prefix 8be9fd
      set -g fish_pager_color_secondary_completion f8f8f2
      set -g fish_pager_color_secondary_description 6272a4

      fish_vi_key_bindings
      bind ctrl-space -M insert accept-autosuggestion
      bind \cg forget_last_command
      bind --mode insert \cg forget_last_command

      zoxide init --cmd cd fish | source
    '';

    plugins = [
      {
        name = "grc";
        inherit (pkgs.fishPlugins.grc) src;
      }
      {
        name = "z";
        inherit (pkgs.fishPlugins.z) src;
      }
      {
        name = "fzf-fish";
        inherit (pkgs.fishPlugins.fzf-fish) src;
      }
      {
        name = "plugin-git";
        inherit (pkgs.fishPlugins.plugin-git) src;
      }
    ];
  };
}
