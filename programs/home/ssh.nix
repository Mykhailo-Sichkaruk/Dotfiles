{ ... }:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = {
      "bos-jump" = {
        hostname = "bos-2025.ipsec.info";
        user = "xsichkaruk";
        identityFile = "~/.ssh/bos_class_vm";
        identitiesOnly = true;
        addKeysToAgent = "yes";
        forwardAgent = false;
      };

      "bos-vm" = {
        hostname = "bos-xsichkaruk.local";
        user = "user";
        proxyJump = "bos-jump";
        identityFile = "~/.ssh/bos_class_vm";
        identitiesOnly = true;
        addKeysToAgent = "yes";
        forwardAgent = false;

        controlMaster = "auto";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "4h";
      };

      "*" = {
        forwardAgent = false;
      };
    };
  };
}
