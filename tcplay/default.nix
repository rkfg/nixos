{ stdenv, fetchFromGitHub, cmakeCurses, pkgconfig, devicemapper, libuuid, libgcrypt, openssl, libgpgerror }:

stdenv.mkDerivation rec {
  name = "tcplay-2.0";

  src = fetchFromGitHub {
    owner = "bwalex";
    repo = "tc-play";
    rev = "a93a2456b7c6d2aa9ce0c86f11f24b5dca5619e4";
    sha256 = "0z1wq0nzfrvjnz8q5lxya297l5v03fdc12yslra56r4c3pi5qa47";
  };

  nativeBuildInputs = [ cmakeCurses pkgconfig ];
  buildInputs = [ devicemapper libuuid libgcrypt openssl libgpgerror ];

  meta = with stdenv.lib; {
    description = "A free TrueCrypt replacement";
    longDescription = ''
      tcplay is a free (BSD-licensed), pretty much fully featured
      (including multiple keyfiles, cipher cascades, etc) and stable TrueCrypt implementation.
    '';
    homepage = https://github.com/bwalex/tc-play;
    license = licenses.bsd2;
    platforms = platforms.linux;
  };
}
