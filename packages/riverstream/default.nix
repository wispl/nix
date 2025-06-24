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
    rev = "8eade35fb45a1531d63fd2202b412b0bda0915bf";
    sha256 = "Opu9xeCo7H4gM+IWq8bdypswtBFDbKSJVjRAs4oA5GY=";
  };

  makeFlags = ["PREFIX=${placeholder ''out''}"];
  nativeBuildInputs = [wayland wayland-scanner];
  buildInputs = [wayland];
}
