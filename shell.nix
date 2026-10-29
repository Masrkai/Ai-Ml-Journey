{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    julia-bin
    git
    gnumake
  ];

  shellHook = ''
    echo "=========================================="
    echo " Welcome to AI/ML/Data Science with Julia!"
    echo " Julia version: $(julia --version)"
    echo "=========================================="
  '';
}
