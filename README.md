# Il Linguaggio di Programmazione Rust

(The Rust Programming Language)

This repository contains the source of the Italian version of "The Rust Programming Language" book.

## How to build

The Book can easily be built by running `nix build` in the root of the project (N.B.: First make sure that the Nix package manager is available and configured to execute the `nix` commands and to support the Flake interface).

## How to contribute

Along with the scripts needed to build a distribution of the Book, the Flake present in this repository is equipped with everything that is necessary to spawn a full-fledged environment useful to work on it; therefore, you can get the correct versions of `mdbook`, `cargo` and `rustc` just by typing `nix develop` in your shell.

Once everything is set up, you can quickly check your work by launching `mdbook serve --open` and a locally-hosted page with your version of the Book should pop up in your default browser.

In case you want to contribute your changes, you then only have to commit your improvements, create a Pull Request and wait for it to be merged.
