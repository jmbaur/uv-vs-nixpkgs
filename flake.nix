{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = inputs: {
    devShells =
      inputs.nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ]
        (system: {
          default =
            let
              pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
            in
            pkgs.mkShell {
              packages = [ pkgs.uv ];
              env.UV_PYTHON = pkgs.lib.getExe pkgs.python3;
              # hack required for numpy downloaded by uv to work
              env.LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
                pkgs.libgcc.lib
                pkgs.zlib
              ];
            };
        });

    legacyPackages = inputs.nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ] (
      system:
      import inputs.nixpkgs {
        inherit system;
        overlays = [
          (final: prev: {
            test1 = final.python3.pkgs.callPackage ./packages/test1 { };
            test2 =
              (final.python3.pkgs.overrideScope (
                pyfinal: pyprev: {
                  numpy = pyprev.numpy.overrideAttrs (old: {
                    version = "2.4.0";
                    src = final.fetchFromGitHub {
                      owner = "numpy";
                      repo = "numpy";
                      tag = "v2.4.0";
                      fetchSubmodules = true;
                      hash = "sha256-ChR9w+DB1STD8RdqIBpTFS0Wvok7y6mdyj9ScJbMe8s=";
                    };
                  });
                }
              )).callPackage
                ./packages/test2
                { };
          })
        ];
      }
    );
  };
}
