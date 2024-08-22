let
nixpkgs = import (builtins.fetchTarball https://github.com/NixOS/nixpkgs/archive/20.03.tar.gz) {
  overlays = [];
  config = {};
};

installNodeJS = import (./nodejs.nix) {
  inherit nixpkgs;
  version = "20.0.0";
  sha256 = "${if nixpkgs.stdenv.isDarwin then "sha256-c+hu0pZt2nd4IP0C6u17sYgZnggkx4IfxASrns3Fh30=" else "sha256-c+hu0pZt2nd4IP0C6u17sYgZnggkx4IfxASrns3Fh30="}";
};
frameworks = nixpkgs.darwin.apple_sdk.frameworks;


in
with nixpkgs;

stdenv.mkDerivation {
  name = "nodejs-env";
  buildInputs = [ installNodeJS ];

  nativeBuildInputs = [
    zsh
    vim
  ] ++ (
    stdenv.lib.optionals stdenv.isDarwin [
      frameworks.Security
      frameworks.CoreServices
      frameworks.CoreFoundation
      frameworks.Foundation
    ]
  );

  # Post Shell Hook  and change time zone
  shellHook = ''
    export TZ=America/New_York
  '';
}
