{
  makeWrapper,
  obs-studio,
  symlinkJoin,
}:

symlinkJoin {
  name = "obs-studio-nvenc-${obs-studio.version}";
  paths = [ obs-studio ];
  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    for program in obs obs-nvenc-test; do
      wrapProgram "$out/bin/$program" \
        --prefix LD_LIBRARY_PATH : /run/opengl-driver/lib
    done
  '';

  inherit (obs-studio) meta;
  passthru = (obs-studio.passthru or { }) // {
    unwrapped = obs-studio;
  };
}
