{
  autoCmd = [
    {
      event = [ "TextYankPost" ];
      desc = "Highlight yanked text";
      callback.__raw = ''
        function()
          vim.highlight.on_yank({ timeout = 150 })
        end
      '';
    }
    {
      event = [
        "FocusGained"
        "TermClose"
        "TermLeave"
      ];
      desc = "Reload files changed outside Neovim";
      command = "checktime";
    }
  ];
}
