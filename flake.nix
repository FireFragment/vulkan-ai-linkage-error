{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, flake-utils, nixpkgs, rust-overlay }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = (import nixpkgs) {
          inherit system;
          overlays = [
            (import rust-overlay)
          ];
        };

        rust = pkgs.rust-bin.stable.latest.default.override {
          extensions = [ "rust-src" "cargo" "rustc" "rustfmt" ];
        };

        vulkan = pkgs.symlinkJoin {
          name = "vulkan_sdk";
          paths = with pkgs; [ vulkan-headers vulkan-loader ];
        };

      in rec {

        devShell = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [ rust cargo llvmPackages.clang vulkan-tools shaderc
    vulkan-headers
    vulkan-loader gcc11 alsa-lib rocmPackages.hipcc ];
          LIBCLANG_PATH = "${pkgs.llvmPackages_16.libclang.lib}/lib";

          LD_LIBRARY_PATH="/run/opengl-driver/lib/:${pkgs.glfw}/lib:${pkgs.freetype}/lib:${pkgs.vulkan-loader}/lib:${pkgs.vulkan-validation-layers}/lib";

          VULKAN_SDK = vulkan;

          RUST_SRC_PATH = "${rust}/lib/rustlib/src/rust/library";


          buildInputs = with pkgs; [
            openssl.dev
            glib.dev
            pkg-config
          ];
        };
      }
    );
}
