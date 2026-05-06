{
  description = "A flake that manages both NixOS and Home Manager configurations along with dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-cuda.url = "github:nixos/nixpkgs/nixos-25.11-small";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nur.url = "github:nix-community/NUR";
    nix-auth.url = "github:numtide/nix-auth";
    nixvim.url = "github:nix-community/nixvim/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl.url = "github:nix-community/nixGL";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };

  nixConfig = {
    extra-substituters = [ "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-cuda,
      nixpkgs-unstable,
      nur,
      nix-auth,
      nixvim,
      home-manager,
      nix-index-database,
      nixgl,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          nixgl.overlay
          nur.overlays.default
        ];
      };
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs-cuda = import nixpkgs-cuda {
        inherit system;
        config = {
          allowUnfree = true;
          cudaSupport = true;
          cudaCapabilities = [ "8.6" ];
        };
      };
      pkgs-nix-auth = import nix-auth {
        inherit system;
      };
      cudaRuntimeLibraryPath = pkgs.lib.makeLibraryPath [
        pkgs-cuda.cudaPackages.cuda_cudart
        pkgs-cuda.cudaPackages.libcublas
      ];
      whisperCppCuda = pkgs-cuda.whisper-cpp.override {
        cudaSupport = true;
      };
      whisperCppCudaRunner = pkgs.writeShellScriptBin "whisper-cpp-cuda" ''
        export __NV_PRIME_RENDER_OFFLOAD=1
        export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
        export __GLX_VENDOR_LIBRARY_NAME=nvidia
        export __VK_LAYER_NV_optimus=NVIDIA_only
        export LD_LIBRARY_PATH="/run/opengl-driver/lib:/run/opengl-driver-32/lib:${cudaRuntimeLibraryPath}:$LD_LIBRARY_PATH"
        exec ${whisperCppCuda}/bin/whisper-cli "$@"
      '';
      archiMcpPort = 8766;
      localPackages = rec {
        archi = pkgs.callPackage ./pkgs/by-name/ar/archi/package.nix {
          inherit archiMcpPort;
        };
        jarchi = pkgs.callPackage ./pkgs/by-name/ja/jarchi/package.nix {
          inherit archi;
        };
        archiMcpPlugin = pkgs.callPackage ./pkgs/by-name/ar/archi-mcp-plugin/package.nix {
          port = archiMcpPort;
        };
        archiDropins = pkgs.symlinkJoin {
          name = "archi-dropins";
          paths = [
            jarchi
            archiMcpPlugin
          ];
        };
        nixvimMinimal = import ./pkgs/by-name/ni/nixvim-minimal/package.nix {
          inherit
            nixvim
            pkgs
            pkgs-unstable
            system
            ;
        };
        playwrightBrowsers1217 =
          pkgs.callPackage ./pkgs/by-name/pl/playwright-browsers-1217/package.nix
            { };
      };
    in
    {
      packages.${system} = localPackages // {
        nixvim-minimal = localPackages.nixvimMinimal;
        playwright-browsers-1217 = localPackages.playwrightBrowsers1217;
        whisper-cpp-cuda = whisperCppCudaRunner;
      };

      devShells.${system} = {
        playwright-1217 = pkgs.mkShell {
          packages = [
            pkgs.nodejs
            pkgs.yarn
            localPackages.playwrightBrowsers1217
          ];

          shellHook = ''
            export PLAYWRIGHT_BROWSERS_PATH=${localPackages.playwrightBrowsers1217}
          '';
        };

        cuda-whisper = pkgs-cuda.mkShell {
          packages = [
            pkgs-cuda.ffmpeg
            whisperCppCudaRunner
            whisperCppCuda
          ];

          shellHook = ''
            export __NV_PRIME_RENDER_OFFLOAD=1
            export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
            export __GLX_VENDOR_LIBRARY_NAME=nvidia
            export __VK_LAYER_NV_optimus=NVIDIA_only
            export LD_LIBRARY_PATH="/run/opengl-driver/lib:/run/opengl-driver-32/lib:${cudaRuntimeLibraryPath}:$LD_LIBRARY_PATH"
            echo "CUDA Whisper shell: use whisper-cpp-cuda with a ggml model and WAV input."
          '';
        };
      };

      apps.${system} = {
        nixvim-minimal = {
          type = "app";
          program = "${localPackages.nixvimMinimal}/bin/nixvim-minimal";
        };

        whisper-cpp-cuda = {
          type = "app";
          program = "${whisperCppCudaRunner}/bin/whisper-cpp-cuda";
        };
      };

      nixosConfigurations.MS_NixLaptop = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          {
            nixpkgs.overlays = [
              nixgl.overlay
              nur.overlays.default
            ];
            nixpkgs.config.allowUnfree = true;
          }
          nix-index-database.nixosModules.default
          ./hosts/MS_NixLaptop/default.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = {
              inherit pkgs-unstable;
              inherit pkgs-nix-auth;
              inherit localPackages;
            };
            home-manager.users.ms = import ./homes/ms/default.nix;
          }
        ];
      };
    };
}
