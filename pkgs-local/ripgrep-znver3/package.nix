{ ripgrep }:

ripgrep.overrideAttrs (
  oldAttrs:
  let
    oldEnv = oldAttrs.env or { };
  in
  {
    pname = "ripgrep-znver3";

    env = oldEnv // {
      RUSTFLAGS = "${oldEnv.RUSTFLAGS or ""} -C target-cpu=znver3";
    };
  }
)
