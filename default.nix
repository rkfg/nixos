{ stdenv, pkgs }:

with pkgs;
{
  tcplay = callPackage ./tcplay {};
}
