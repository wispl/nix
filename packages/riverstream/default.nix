{
  lib,
  stdenv,
  fetchFromGitHub,
  wayland,
  wayland-scanner,
}:
stdenv.mkDerivation rec {
  name = "riverstream";
  src = fetchFromGitHub {
    owner = "wispl";
    repo = "riverstream";
    rev = "a1bc84dcfc62d1297c123b07ae547ae76fab182f";
    sha256 = "GdJtTy5FRloj4aALyE1LuKNC9Ro7y7SRHoQ4OfgR9D0=";
  };

  makeFlags = ["PREFIX=${placeholder ''out''}"];
  nativeBuildInputs = [wayland wayland-scanner];
  buildInputs = [wayland];
}
