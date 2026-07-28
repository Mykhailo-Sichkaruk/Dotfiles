{ ... }:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "bos-jump" = {
        HostName = "bos-2025.ipsec.info";
        User = "xsichkaruk";
        IdentityFile = "~/.ssh/bos_class_vm";
        IdentitiesOnly = true;
        AddKeysToAgent = "yes";
        ForwardAgent = false;
      };

      "bos-vm" = {
        HostName = "bos-xsichkaruk.local";
        User = "user";
        ProxyJump = "bos-jump";
        IdentityFile = "~/.ssh/bos_class_vm";
        IdentitiesOnly = true;
        AddKeysToAgent = "yes";
        ForwardAgent = false;

        ControlMaster = "auto";
        ControlPath = "~/.ssh/master-%r@%n:%p";
        ControlPersist = "4h";
      };

      "*.render.com" = {
        IdentityFile = "~/.ssh/uniit_render_id_ed25519";
        IdentitiesOnly = true;
        AddKeysToAgent = "yes";
        ForwardAgent = false;
      };

      "*" = {
        ForwardAgent = false;
      };
    };
  };
}
