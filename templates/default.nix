# nix flake init -t github:anshulnoori/nixos-config#<template>
{
  python = {
    path = ./python;
    description = "Python devShell with pyright LSP + formatter";
  };
  rust = {
    path = ./rust;
    description = "Rust devShell with rust-analyzer + clippy";
  };
  node = {
    path = ./node;
    description = "Node.js / TypeScript devShell with ts-ls";
  };
  java = {
    path = ./java;
    description = "Java devShell with jdtls";
  };
  cpp = {
    path = ./cpp;
    description = "C / C++ devShell with clangd + cmake";
  };
}
