{ ... }:

{
  programs.git = {
    enable = true;
    signing = {
      key = "7E61AB8D3230325AEF773B7BFC4A9CC75051A225";
      signByDefault = true;
    };
    settings = {
      credential."https://github.com".helper = [
        ""
        "!/home/ms/.nix-profile/bin/gh auth git-credential"
      ];
      credential."https://gist.github.com".helper = [
        ""
        "!/home/ms/.nix-profile/bin/gh auth git-credential"
      ];
      user = {
        name = "Mykhailo Sichkaruk";
        email = "mykhailo.sichkaruk@gmail.com";
      };
      core.editor = "nvim";
      commit.gpgsign = true;
      init.defaultBranch = "main";
      diff.tool = "vimdiff";
      sequence.editor = "nvim";
      safe.directory = "/";
      http.postBuffer = 924288000;
    };
  };
}
