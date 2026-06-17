{
  inputs,
  stdenv,
  symlinkJoin,
  makeWrapper,
  ...
}:
let
  system = stdenv.hostPlatform.system;
  niri = inputs.niri.packages.${system}.niri;
  niri-base = niri.overrideAttrs (old: {
    doCheck = false; # skip tests
  });
in
symlinkJoin {
  inherit (niri-base)
    meta
    pname
    version
    passthru
    cargoBuildFeatures
    cargoBuildNoDefaultFeatures
    ;

  name = "niri-patched";
  paths = [ niri-base ];
  buildInputs = [ makeWrapper ];

  # Silence the deprecated import-environment warning
  postBuild = ''
    # bash
    rm $out/bin/niri-session
    cp ${niri-base}/bin/niri-session $out/bin/niri-session
    sed -i 's|systemctl --user import-environment|systemctl --user import-environment 2> /dev/null|' $out/bin/niri-session
    chmod +x $out/bin/niri-session
  '';
}
