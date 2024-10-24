{
  inputs = {
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    gptmdt = {
      url = "github:Rust-User-Group-VR/gpt_md_translator";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, fenix, gptmdt, nixpkgs, ... }: let
    pkgs = import nixpkgs { system = "x86_64-linux"; };
  in {
    packages."x86_64-linux".default = pkgs.stdenvNoCC.mkDerivation {
      pname = "rust_book_ita";
      version = "2.0.0";

      src = ./.;
      buildInputs = with pkgs; [
        mdbook
      ];

      buildPhase = ''
        mdbook build
      '';

      installPhase = ''
        cp -r book/ $out/
      '';
    };
    devShells."x86_64-linux".default = pkgs.mkShell {
      name = "rust_book_ita_devenv";
      packages = (with pkgs; [
        mdbook
        rust-analyzer
      ]) ++ (with fenix.packages."x86_64-linux";
        [ (combine [
          stable.cargo
          stable.rustc
        ]) ]
      ) ++ [
        gptmdt.packages."x86_64-linux".default
        (import ./nix/translator_helper.nix { inherit pkgs; })
      ];
    };
  };
}
