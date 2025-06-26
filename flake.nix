{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };
  outputs = { nixpkgs, lib, ... }: let
    pkgs = import nixpkgs {
      system = "x86_64-linux";
    };
    inherit (lib.strings) cmakeBool;
  in {
    devShells."x86_64-linux".default = pkgs.mkShell {
      nativeBuildInputs = with pkgs; [
        cmake python3Minimal
      ];
      hardeningDisable = [ "all" ];
    };
    packages."x86_64-linux".default = pkgs.stdenv.mkDerivation {
      pname = "MinimalSocket";
      version = "v3.1";

      src = ./.;
      strictDeps = true;
      cmakeFlags = [
        (cmakeBool "BUILD_MinimalCppSocket_SAMPLES" false)
        (cmakeBool "BUILD_MinimalCppSocket_TESTS" false)
        (cmakeBool "LIB_OPT" true)
      ];

      nativeBuildInputs = with pkgs; [
        cmake
        python3Minimal
      ];

      meta = {
        homepage = "https://github.com/andreacasalino/Minimal-Socket";
        description = "Minimal cross platform C++ tcp, udp socket implementation";
        license = lib.licenses.gpl3;
        platforms = lib.platforms.unix;
      };

    };
  };
}
